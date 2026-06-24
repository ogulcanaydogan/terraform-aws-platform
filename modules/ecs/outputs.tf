output "cluster_arn" {
  description = "Cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "service_arn" {
  description = "Service ARN."
  value       = aws_ecs_service.this.id
}
