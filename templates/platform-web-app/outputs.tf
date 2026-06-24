output "alb_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = module.alb.load_balancer_dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL to push the application image to"
  value       = module.ecr.repository_url
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs.cluster_arn
}

output "rds_endpoint" {
  description = "Postgres connection endpoint"
  value       = module.rds.db_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
