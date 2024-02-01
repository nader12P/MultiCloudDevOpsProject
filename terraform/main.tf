terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  
  # Comment on initial apply #

  # backend "s3" {
  #   bucket         = "ivolve-prject-s3"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  # }

  # Comment on initial apply #

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

resource "aws_s3_bucket" "statefile-bucket" {
  bucket = "ivolve-prject-s3"
  bucket_encrypt = true
  tags = {
    Name        = "statefile-bucket"
  }
}

#********************************************************************************************************#
# VPC MODULE                                                                                             #
#********************************************************************************************************#

module "vpc" {
    source = "./vpc"
    cidr_block = var.cidr_block
    pub_sub_id = module.subnets.pub_sub_id
}


#********************************************************************************************************#
# Subnets MODULE                                                                                         #
#********************************************************************************************************#

module "subnets" {
    source = "./subnet"
    vpc_id = module.vpc.vpc_id
    pub_sub_cidr_block = var.pub_sub_cidr_block
    pub_sub_name = var.pub_sub_name
    map_ip = var.map_ip
}


#********************************************************************************************************#
# SG MODULE                                                                                              #
#********************************************************************************************************#

module "security_groups" {
    source = "./sg"
    vpc_id = module.vpc.vpc_id
}


#********************************************************************************************************#
# EC2 MODULE                                                                                             #
#********************************************************************************************************#

module "ec2" {
    source = "./ec2"
    instance_type = var.instance_type
    pub_sub_id = module.subnets.pub_sub_id
    pub_sg_id = module.security_groups.pub_sg_id
    key_name = var.key_name
}

#********************************************************************************************************#
# CloudWatch MODULE                                                                                      #
#********************************************************************************************************#

module "clouddwatch_alarm" {
    source = "./cloudwatch_alarm"
    instance_id = module.ec2.instance_id
    email = var.email
}

#********************************************************************************************************#
# S3 Backend                                                                                             #
#********************************************************************************************************#

# module "s3_backend" {
#   source = "./s3_backend"
#   bucket_name = var.bucket_name
#   bucket_key = var.bucket_key
#   bucket_region = var.bucket_region
#   bucket_encrypt = var.bucket_encrypt
# }