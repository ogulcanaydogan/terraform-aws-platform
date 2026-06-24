locals {
  name = var.name
  tags = var.tags
}

# ---------------------------------------------------------------------------
# Network: VPC with public subnets (ALB) and private subnets (tasks + DB)
# ---------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  name                 = local.name
  cidr_block           = var.cidr_block
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.tags
}

# ---------------------------------------------------------------------------
# Security groups: public ALB, private service, private database
# ---------------------------------------------------------------------------
module "alb_sg" {
  source = "../../modules/sg"

  name        = "${local.name}-alb"
  description = "ALB ingress from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.tags
}

module "service_sg" {
  source = "../../modules/sg"

  name        = "${local.name}-service"
  description = "ECS service ingress from within the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "App port from VPC"
      from_port   = var.container_port
      to_port     = var.container_port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }
  ]

  tags = local.tags
}

module "db_sg" {
  source = "../../modules/sg"

  name        = "${local.name}-db"
  description = "Postgres ingress from within the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Postgres from VPC"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }
  ]

  tags = local.tags
}

# ---------------------------------------------------------------------------
# Container registry for the application image
# ---------------------------------------------------------------------------
module "ecr" {
  source = "../../modules/ecr"

  name = local.name
  tags = local.tags
}

# ---------------------------------------------------------------------------
# Public Application Load Balancer (forwards to the Fargate service)
# ---------------------------------------------------------------------------
module "alb" {
  source = "../../modules/alb"

  name               = "${local.name}-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]
  target_port        = var.container_port
  target_type        = "ip" # Fargate awsvpc tasks register by IP
  health_check_path  = var.health_check_path
  tags               = local.tags
}

# ---------------------------------------------------------------------------
# IAM roles and logging for the ECS task
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.name}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${local.name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  tags               = local.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.name}"
  retention_in_days = 14
  tags              = local.tags
}

# ---------------------------------------------------------------------------
# ECS Fargate service running the container, behind the ALB
# ---------------------------------------------------------------------------
module "ecs" {
  source = "../../modules/ecs"

  name               = local.name
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.service_sg.security_group_id]
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  container_image    = var.container_image
  container_port     = var.container_port
  desired_count      = var.desired_count
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn
  log_group_name     = aws_cloudwatch_log_group.ecs.name
  target_group_arn   = module.alb.target_group_arn
  tags               = local.tags
}

# ---------------------------------------------------------------------------
# Private Postgres database for the application
# ---------------------------------------------------------------------------
module "rds" {
  source = "../../modules/rds"

  name                   = "${local.name}-db"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.db_sg.security_group_id]
  tags                   = local.tags
}
