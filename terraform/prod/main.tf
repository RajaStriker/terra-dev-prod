provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "angular_prod_bucket" {
  bucket = var.prod_bucket_name
  acl    = "private"
}

resource "aws_instance" "angular_prod_instance" {
  ami           = var.prod_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Angular Prod Instance"
  }
}

