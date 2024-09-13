provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "angular_dev_bucket" {
  bucket = var.dev_bucket_name
  acl    = "private"
}

resource "aws_instance" "angular_dev_instance" {
  ami           = var.dev_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Angular Dev Instance"
  }
}

