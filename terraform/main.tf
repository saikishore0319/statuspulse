terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "./modules/vpc"
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = "${var.aws_region}a"
}

module "security_group" {
  source         = "./modules/security_group"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  ssh_allowed_ip = var.ssh_allowed_ip
}

module "ec2" {
  source                        = "./modules/ec2"
  project_name                  = var.project_name
  ami_id                        = var.ami_id
  instance_type                 = var.instance_type
  subnet_id                     = module.vpc.subnet_id
  security_group_id             = module.security_group.security_group_id
  key_name                      = var.key_name
  root_volume_size              = var.root_volume_size
  enable_termination_protection = var.enable_termination_protection
}
