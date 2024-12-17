# Variables
variable "aws_access_key" {
  type        = string
  description = "Access key for AWS"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key for AWS"
  sensitive   = true
}

# Provider Configuration
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Security Group
resource "aws_security_group" "terra_web_sg" {
  name = "terraWebAppSecurityGroup"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["77.47.209.92/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.47.209.92/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "terra_web_application" {
  ami             = "ami-0866a3c8686eaeeba" # Ubuntu 24.04, amd64
  instance_type   = "t2.micro"
  key_name        = "Key for Web Application Instance"
  security_groups = [aws_security_group.terra_web_sg.name]
  tags = {
    Name = "Terraform Web Application"
  }
  user_data = file("${path.module}/init_ec2.sh")
}

output "terra_web_application_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.terra_web_application.public_ip
}
