terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  #Choose a region near you
}

#Creating  an EC2 Instance

resource "aws_instance" "JenkinsEC2" {
  ami                    = "ami-04b4f1a9cf54c11d0"   # Choose the AMI you want for the creation of your instance
  instance_type          = "t2.micro"                # Choose a size for the instance
  vpc_security_group_ids = [aws_security_group.JenkinsSecG.id]
    key_name               = "Ec2Keypair"
  subnet_id              = "subnet-0f9705a8a66fbd289"
  

  #User Data To Install Jenkins
  user_data = file("user_jenkins.sh")   #This will be the script to grab your user data file for the EC2 instance when it creates
  tags = {
    Name = "JenkinsEC2"
  }
}
#Create a Security Group For the Server
resource "aws_security_group" "JenkinsSecG" {
  name        = "JenkinsSecG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = "vpc-090bab833d6c0d6e5"   #Grab your default VPC ID

  tags = {
    Name = "JenkinsSecG"
  }

  #Allow Acces on port 8080
  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow Traffic on port 443
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Allow access on port 22
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["66.108.66.189/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#S3 Bucket
resource "aws_s3_bucket" "jenkins5157" {
  bucket = "jenkins-5157"
}

resource "aws_s3_bucket_public_access_block" "jenkins_acl" {
  bucket = aws_s3_bucket.jenkins5157.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}