variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming"
  type        = string
  default     = "statuspulse"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID"
  type        = string
  default     = "ami-007020fd9c84e18c7" # Ubuntu 22.04 LTS in ap-south-1
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.medium"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 access"
  type        = string
}

variable "ssh_allowed_ip" {
  description = "IP address or CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_termination_protection" {
  description = "Enables EC2 instance termination protection"
  type        = bool
  default     = true
}
