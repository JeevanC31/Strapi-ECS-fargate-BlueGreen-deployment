## Strapi ECS Fargate Blue/Green Deployment

This project demonstrates production-grade deployment of a Strapi v5 application using:

- Docker
- AWS ECR
- Amazon ECS (Fargate)
- Application Load Balancer
- AWS CodeDeploy (Blue/Green)
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)

## Architecture Overview
```text
Developer Push → GitHub Actions
        ↓
Build Docker Image
        ↓
Push to Amazon ECR
        ↓
Render ECS Task Definition
        ↓
Deploy via CodeDeploy (Blue/Green)
        ↓
Traffic Shift via ALB
```
## Project Structure
```text
.
├── strapi-app/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── alb/
│       ├── ecs/
│       ├── rds/
│       ├── security/
│       ├── codedeploy/
│       └── ecr/
│
└── .github/
    └── workflows/
        ├── deploy-app.yml
        └── terraform-infra.yml
```
# Pipeline Steps

- Checkout code
- Configure AWS credentials
- Login to ECR
- Build Docker image
- Push image to ECR
- Render ECS task definition
- Deploy via CodeDeploy (Blue/Green)

## Blue/Green Deployment

Deployment Strategy:
      - Blue = Current production
      - Green = New version
      - Health check validation
      - Traffic shifted gradually
      - Old version drained automatically

Deployment configuration:-
```bash
CodeDeployDefault.ECSCanary10Percent5Minutes
```
## Accessing the Application

Go to:
```bash
http://<ALB-DNS>
```