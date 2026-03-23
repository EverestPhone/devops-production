provider "aws" {
  region = var.aws_region
}

# -------------------
# VPC (Networking)
# -------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# -------------------
# Internet Gateway
# -------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# -------------------
# Security Group
# -------------------
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# -------------------
# EC2 (Compute Layer)
# -------------------
resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux (example)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "devops-app-server"
  }
}

# -------------------
# Logging (CloudWatch)
# -------------------
resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/devops/app"
}