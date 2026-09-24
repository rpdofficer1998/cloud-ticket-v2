# CloudTicket V2

CloudTicket V2 is a cloud-native ticket booking application designed to demonstrate **AWS cloud infrastructure, Infrastructure as Code, containerisation, security, and CI/CD practices**.

The project is being rebuilt from the ground up with a stronger focus on cloud architecture and operational practices rather than application development alone.

## Project Goals

CloudTicket V2 is designed to demonstrate:

* AWS cloud architecture
* Infrastructure as Code with Terraform
* Containerisation with Docker
* Secure AWS networking
* IAM least-privilege design
* Encryption with AWS KMS
* Private application and database subnets
* VPC endpoints for private AWS service access
* EC2 deployment and management through AWS Systems Manager
* Amazon ECR for container image storage
* Amazon SQS for asynchronous event processing
* GitHub Actions CI/CD
* GitHub OIDC authentication to AWS
* Secure and repeatable application deployment

## Architecture

The planned AWS architecture includes:

```text
                         GitHub
                            │
                            │ Git Push
                            ▼
                    GitHub Actions
                            │
                            │ OIDC
                            ▼
                       AWS IAM Role
                            │
                            ▼
                          ECR
                            │
                            │ Docker image
                            ▼
                  ┌─────────────────────┐
                  │     AWS VPC         │
                  │                     │
                  │  Public Subnets     │
                  │        │            │
                  │       ALB           │
                  │        │            │
                  │  Private Subnets    │
                  │        │            │
                  │       EC2           │
                  │        │            │
                  │       RDS           │
                  │                     │
                  │   VPC Endpoints     │
                  │   S3 / SSM / ECR    │
                  └─────────────────────┘
                            │
                           SQS
```

The architecture is being implemented incrementally, so some components shown above may still be under development.

## Tech Stack

### Application

* Node.js
* Express
* PostgreSQL
* REST API
* Docker
* Docker Compose

### AWS

* Amazon VPC
* Amazon EC2
* Amazon RDS
* Amazon ECR
* Amazon SQS
* AWS Systems Manager
* AWS IAM
* AWS KMS
* Amazon S3
* VPC Endpoints

### Infrastructure & DevOps

* Terraform
* Packer
* GitHub Actions
* GitHub OIDC
* Linux
* AWS CLI

## Application Features

The backend currently supports:

* Viewing available events
* Ticket reservation
* Order expiration
* Ticket cancellation
* Ticket restoration
* Payment processing
* Automatic restoration of expired orders
* PostgreSQL transactions
* Row-level locking with `SELECT FOR UPDATE`
* Order event publishing through Amazon SQS

## Infrastructure

Terraform is used to manage the AWS infrastructure through reusable modules.

Current infrastructure work includes:

```text
terraform/
├── modules/
│   ├── ec2/
│   ├── ecr/
│   ├── iam/
│   ├── kms/
│   ├── networking/
│   ├── security-groups/
│   ├── sqs/
│   └── vpc-endpoints/
├── bootstrap/
└── main.tf
```

The infrastructure is designed around private networking and controlled access between components.

For example:

```text
EC2
 │
 ├── HTTPS 443 ──► SSM VPC Endpoints
 │
 ├── HTTPS 443 ──► ECR VPC Endpoints
 │
 └── PostgreSQL 5432 ──► RDS
```

Security groups are used to restrict communication between these components rather than allowing broad network access.

## Security

Security is considered throughout the project rather than being added after the infrastructure is built.

Current security practices include:

* IAM roles instead of long-lived AWS access keys on EC2
* GitHub Actions authentication through OIDC
* Restricted GitHub OIDC trust conditions
* IAM least-privilege policies
* Private EC2 networking
* Private database subnets
* Security-group based network controls
* IMDSv2 required on EC2
* Encrypted EBS volumes
* KMS encryption for AWS resources
* Encrypted ECR repository
* VPC endpoints for private AWS service access
* AWS Systems Manager instead of requiring SSH access for normal administration

## CI/CD

The CI/CD pipeline is being built separately from Terraform infrastructure management.

### Infrastructure

```text
Terraform
   │
   ├── VPC
   ├── Subnets
   ├── Security Groups
   ├── EC2
   ├── RDS
   ├── ECR
   ├── SQS
   ├── KMS
   ├── VPC Endpoints
   └── IAM
```

### Application

```text
Git Push
   │
   ▼
GitHub Actions
   │
   ├── Test / Validate
   ├── Docker Build
   └── Push Image
          │
          ▼
         ECR
          │
          ▼
     EC2 Deployment
```

GitHub Actions uses **OIDC federation with AWS IAM** rather than storing a long-lived AWS access key in GitHub Secrets.

## Project Status

CloudTicket V2 is currently under active development.

The current focus is on:

* Completing AWS infrastructure
* Building the secure networking layer
* Configuring EC2 and Systems Manager
* Configuring ECR and private access
* Integrating SQS
* Building the GitHub Actions CI/CD pipeline
* Validating the complete deployment workflow

Screenshots and the final architecture documentation will be added after the V2 environment has been successfully deployed and validated.

## Author

Zhenyu Tan

Master of Information Technology
