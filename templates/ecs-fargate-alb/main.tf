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

module "service_sg" {
  source      = "../../modules/sg"
  name        = "${local.name}-svc-sg"
  description = "Service security group"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "From ALB"
      from_port   = var.container_port
      to_port     = var.container_port
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
  target_port        = var.container_port
  target_type        = "ip"
  tags               = local.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.name}"
  retention_in_days = 14

  tags = local.tags
}

resource "aws_iam_role" "execution" {
  name               = "${local.name}-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${local.name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  tags               = local.tags
}

module "ecs" {
  source             = "../../modules/ecs"
  name               = local.name
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.service_sg.security_group_id]
  container_image    = var.container_image
  container_port     = var.container_port
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn
  log_group_name     = aws_cloudwatch_log_group.ecs.name
  target_group_arn   = module.alb.target_group_arn
  tags               = local.tags
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
