variable "aws_region" {
  description = "AWS region to create resources"
  default     = "us-east-1"
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
  default     = "../my-ssh-key.pem"
}
