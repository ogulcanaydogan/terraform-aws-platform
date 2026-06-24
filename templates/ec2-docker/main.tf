locals {
  name = var.name
  tags = var.tags
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "ssm_role" {
  source                  = "../../modules/iam"
  name                    = "${local.name}-ssm-role"
  assume_role_policy      = data.aws_iam_policy_document.ec2_assume_role.json
  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
  tags                    = local.tags
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "instance_sg" {
  source      = "../../modules/sg"
  name        = "${local.name}-sg"
  description = "Docker host security group"
  vpc_id      = data.aws_vpc.default.id
  ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_ingress_cidrs
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_ingress_cidrs
    },
    {
      description = "App"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = var.allowed_ingress_cidrs
    },
    {
      description = "App"
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = var.allowed_ingress_cidrs
    }
  ]
  tags = local.tags
}

module "docker_instance" {
  source                      = "../../modules/ec2"
  name                        = "${local.name}-instance"
  ami_id                      = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  security_group_ids          = [module.instance_sg.security_group_id]
  iam_instance_profile        = module.ssm_role.instance_profile_name
  associate_public_ip_address = true
  user_data                   = <<-EOT
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker
              usermod -a -G docker ec2-user
              curl -L https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOT
  tags                        = local.tags
}
