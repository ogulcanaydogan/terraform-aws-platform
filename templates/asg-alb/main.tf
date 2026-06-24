locals {
  name = var.name
  tags = var.tags
}

module "vpc" {
  source               = "../../modules/vpc"
  name                 = local.name
  cidr_block           = var.cidr_block
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = true
  tags                 = local.tags
}

module "alb_sg" {
  source      = "../../modules/sg"
  name        = "${local.name}-alb-sg"
  description = "ALB security group"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = local.tags
}

module "app_sg" {
  source      = "../../modules/sg"
  name        = "${local.name}-app-sg"
  description = "App security group"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "HTTP from ALB"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }
  ]
  tags = local.tags
}

module "alb" {
  source             = "../../modules/alb"
  name               = "${local.name}-alb"
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]
  vpc_id             = module.vpc.vpc_id
  target_port        = 80
  tags               = local.tags
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix            = "${local.name}-lt-"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.app_sg.security_group_id]

  user_data = base64encode(<<-EOT
              #!/bin/bash
              dnf install -y httpd
              systemctl enable --now httpd
              echo "Hello from ASG" > /var/www/html/index.html
              EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags, {
      Name = "${local.name}-instance"
    })
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${local.name}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = module.vpc.private_subnet_ids
  target_group_arns   = [module.alb.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
