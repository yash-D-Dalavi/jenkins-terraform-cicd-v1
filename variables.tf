variable "aws_region" {
  description = "AWS region for infrastructure provisioning"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu Server"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Standard Ubuntu 22.04 LTS AMI
}