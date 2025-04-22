# 🕒 SimpleTimeService

A minimal Flask microservice that returns the **current timestamp** and the **visitor’s IP address** in a JSON response.  
Built for DevOps deployment demo using **Docker, Terraform, AWS ECS (Fargate), and Application Load Balancer (ALB)**.

---

## 📁 Repository Structure

```
Simple-Time-Service/
├── app/                         # Flask application
│   ├── app.py                   # Main Flask app that returns timestamp & IP
│   ├── Dockerfile               # Dockerfile to containerize the app
│   ├── requirements.txt         # Python dependencies
│   └── .dockerignore            # Docker ignore rules
│
├── terraform/                   # Terraform IaC for AWS deployment
│   ├── main.tf                  # Main Terraform config
│   ├── variables.tf             # Input variables
│   ├── outputs.tf               # Output values like ALB DNS
│   ├── terraform.tfvars         # Variable values (not committed if sensitive)
│   ├── backend.tf               # Remote backend config (S3 + DynamoDB)
│   └── .gitignore               # Terraform ignores (e.g., .terraform/)
│
├── .gitignore                   # Root-level gitignore
└── README.md                    # Project overview and instructions
```


---

## 🌐 Live Demo

Once deployed, your app will be accessible at:
```
http://<alb-dns-name>
```
(You’ll get this DNS name from Terraform output after deployment.)

---

## 🚀 Quick Start

### 1️⃣ Build & Push Docker Image

```bash
cd app
docker build -t althaf24/simpletimeservice:latest .
docker push althaf24/simpletimeservice:latest
```

---

##  Provision Infrastructure with Terraform

```
cd terraform
terraform init
terraform apply
```
 👉 Follow the output for the alb_dns_name to test your app in a browser.

 ---

#  Features
  1.Python Flask app returns timestamp & IP

  2.Dockerized, runs as non-root user

  3.Deployed on AWS ECS (Fargate)

  4.Exposed via Application Load Balancer

  5.Infrastructure as Code with Terraform

---

# Tech Stack
 1.Python 3.9
 
 2.Flask

 3.Docker

 4.AWS ECS + Fargate

 5.Terraform

 6.AWS ALB, VPC, IAM

---

# 🙌 Author
* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
Built with ❤️ by @malthaf9

Feel free to fork, star ⭐, and improve it!
