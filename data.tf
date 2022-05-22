data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-2.0*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

############# TEST !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!####################
# data "aws_network_interface" "app01-web-nlb-private-ip-2a" {
#   filter {
#     name = "description"
#     values = ["ELB ${aws_lb.sec-app01-web-alb.arn_suffix}"]
#   }

#   filter {
#     name = "availability_zone"
#     values = ["ap-northeast-2a"]
#   }
# }

# data "aws_network_interface" "app01-web-nlb-private-ip-2c" {
#   filter {
#     name = "description"
#     values = ["ELB ${aws_lb.sec-app01-web-alb.arn_suffix}"]
#   }

#   filter {
#     name = "availability_zone"
#     values = ["ap-northeast-2c"]
#   }
# }

variable "aws_region" {
  description = "AWS region"
  default = "ap-northeast-2"
}

variable "app01_web_type" {
  description = "APP01 instance type"
  default = "t2.micro"
}

variable "app01_web_key" {
  description = "WEB keypair in app01 vpc"
  default     = "test-bastion"
}

variable "appliance_bastion_key" {
  description = "Bastion keypair in appliance vpc"
  default     = "test-bastion"
}

variable "appliance_key" {
  description = "Bastion keypair in appliance vpc"
  default     = "test-bastion"
}

