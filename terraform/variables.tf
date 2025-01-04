variable "aws_region" {
  description = "AWS region to create resources"
  default     = "us-east-1"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key to use"
  default     = "my-ssh-key"
}

variable "private_key_path" {
  description = "Path to your private SSH key"
  default     = "./my-ssh-key.pem"
}

# variable "docker_user_name" {
#   description = "Name of your Docker USERNAME"
#   type        = string
# }
#
# variable "dockerhub_pwd" {
#   description = "<PASSWORD>"
#   type        = string
# }
#
# variable "image_name" {
#   description = "Docker Image image to be run on VM Instance"
#   type        = string
#
# }
