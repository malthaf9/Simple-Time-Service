terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}


# Cloud Provider
provider "aws" {
  region = var.aws_region
}

# VPC Module creation
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "simpletimeservice-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "dev"
    Project     = "SimpleTimeService"
  }
}


# ECS Cluster creation
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.8.0"

  name = "simpletimeservice-cluster"

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  tags = {
    Environment = "dev"
    Project     = "SimpleTimeService"
  }
}


# Assign IAM role to ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Assign policy attachment
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS task creation
resource "aws_ecs_task_definition" "simpletimeservice" {
  family                   = "simpletimeservice-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "simpletimeservice"
      image     = "althaf24/simpletimeservice:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}


# Load balancer creation
resource "aws_lb" "alb" {
  name               = "simpletimeservice-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

#Load balancer group
resource "aws_lb_target_group" "tg" {
  name     = "simpletimeservice-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    interval = 30
    timeout  = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Load balancer listner
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


# Security groups to allow traffic
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for ECS
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow traffic from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Service
resource "aws_ecs_service" "simpletimeservice" {
  name            = "simpletimeservice"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.simpletimeservice.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "simpletimeservice"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.listener]
}


# S3 bucket creation
resource "aws_s3_bucket" "tf_state" {
  bucket = "simpletimeservice-tfstate"  # must be globally unique

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "Terraform State"
    Environment = "dev"
  }
}

# Dynamodb Table to maintain state
resource "aws_dynamodb_table" "tf_locks" {
  name         = "simpletimeservice-locks"
  billing_mode = "PAY_PER_REQUEST"  
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Locks"
    Environment = "dev"
  }
}
