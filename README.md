# AWS Terraform Templates Library

This repository provides reusable Terraform modules and ready-to-run templates for common AWS use cases. Each template is self-contained with pinned providers, variables/outputs, tagging, and a README.

## Repository Structure
```
modules/   reusable building blocks
templates/ runnable stacks consuming modules
  <name>/{main.tf, variables.tf, outputs.tf, providers.tf, versions.tf, README.md, terraform.tfvars.example}
docs/      repo documentation
```

## Template Catalog
| Category | Template | What it deploys | Estimated cost risk | Link |
|----------|----------|-----------------|---------------------|------|
| Networking | VPC public/private + NAT | VPC with public/private subnets and NAT gateway | Medium | [templates/vpc-basic](templates/vpc-basic) |
| Networking | VPC endpoints | VPC with S3/DynamoDB gateway endpoints | Low | [templates/vpc-endpoints](templates/vpc-endpoints) |
| Compute | EC2 Docker (SSM) | EC2 with Docker and SSM access | Low | [templates/ec2-docker](templates/ec2-docker) |
| Compute | ASG behind ALB | Auto Scaling Group with ALB | Medium | [templates/asg-alb](templates/asg-alb) |
| Containers | ECR repo | ECR repository | Low | [templates/ecr-repo](templates/ecr-repo) |
| Containers | ECS Fargate behind ALB | ECS Fargate service with ALB | Medium | [templates/ecs-fargate-alb](templates/ecs-fargate-alb) |
| Storage | S3 static site + CloudFront | S3 + CloudFront + ACM + Route53 | Medium | [templates/s3-static-site](templates/s3-static-site) |
| Storage | S3 lifecycle + logs | S3 with lifecycle rules, encryption, access logs | Low | [templates/s3-lifecycle](templates/s3-lifecycle) |
| Databases | RDS Postgres | Private RDS Postgres with parameter group | Medium | [templates/rds-postgres](templates/rds-postgres) |
| Messaging | SNS topic | SNS topic + subscription | Low | [templates/sns-topic](templates/sns-topic) |
| Messaging | SQS queue + DLQ | SQS queue with dead-letter queue | Low | [templates/sqs-queue](templates/sqs-queue) |
| Serverless | Lambda + HTTP API | Lambda function with API Gateway | Low | [templates/lambda-httpapi](templates/lambda-httpapi) |
| Observability | Log metric alarm | Log group, metric filter, alarm + SNS | Low | [templates/cloudwatch-metric-alarm](templates/cloudwatch-metric-alarm) |
| Security | IAM examples | IAM user/role policy examples | Low | [templates/iam-examples](templates/iam-examples) |
| Search | OpenSearch VPC | OpenSearch domain with VPC access | Medium | [templates/opensearch-vpc](templates/opensearch-vpc) |
| Reference | Web app platform | VPC + ECR + RDS Postgres + ECS Fargate behind ALB (end-to-end) | High | [templates/platform-web-app](templates/platform-web-app) |

## Usage
1. Choose a template and review its README.
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and edit values.
3. Run:
   ```bash
   terraform init
   terraform apply
   ```

## Formatting & Validation
- `make fmt`
- `make validate`

## Contributing
See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).
