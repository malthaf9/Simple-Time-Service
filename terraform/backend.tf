terraform {
  backend "s3" {
    bucket         = "simpletimeservice-tfstate"   # Replace with your unique bucket name
    key            = "terraform/ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "simpletimeservice-locks"
    encrypt        = true
  }
}
