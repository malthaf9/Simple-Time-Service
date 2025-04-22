#  Terraform Infrastructure for SimpleTimeService

This folder contains the Terraform code to provision the cloud infrastructure for the **SimpleTimeService** app using **AWS ECS (Fargate)**.

---

## 📁 Project Structure

```bash
terraform/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Input variables
├── terraform.tfvars     # Values for variables (not committed if sensitive)
├── outputs.tf           # Outputs after deployment
├── backend.tf           # S3 + DynamoDB remote state backend config
└── .gitignore           # Prevents committing local Terraform files

```
## What This Terraform Code Does

 1. Provisions a VPC with public & private subnets

 2. Creates an ECS Cluster with Fargate

 3. Deploys a containerized Flask app from Docker Hub

 4. Creates a public-facing Application Load Balancer

 5. Sets up IAM roles, security groups, and target groups

 6. Stores Terraform state in S3 with a DynamoDB lock table

# Prerequisites
 1. AWS CLI configured with credentials

 2. Terraform v1.3.0 or higher

 3. S3 bucket + DynamoDB table (auto-created by Terraform in this project)

#  How to Deploy
Navigate to the Terraform folder
```
cd terraform
```
Initialize Terraform
```
terraform init
```
Validate the configuration
```
terraform validate
```
Review the execution plan
```
terraform plan
```
Apply the changes
```
terraform apply
```
After deployment, copy the ALB DNS output from the terminal and access your app in the browser:
```
http://<alb-dns-name>
```

#  Outputs
vpc_id

public_subnets

private_subnets

alb_dns_name → Visit this to test the service







