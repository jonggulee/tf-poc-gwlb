# test-gwlb-terraform

# Purpose
To create a Centralized inspection architecture using terraform with AWS Gateway Load Balancer and AWS Transit Gateway

# Architecture
<img width="1641" alt="스크린샷 2022-05-24 오후 1 02 49" src="https://user-images.githubusercontent.com/102651396/169946476-c3648661-8d5c-46ff-9af9-af460b7966ce.png">

# Prerequisites
Created AWS Key pair
Completion of AWS configuration and credential file settings

# Getting Started
Git clone
```
$ git clone https://github.com/MZCBBD/test-gwlb-terraform.git
```

Open data.tf in a text editor then update the key pair
```
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
```
Execute the following command on local.
```
$ terraform init
$ terraform apply -auto-approve
```

# APPENDIX
https://whchoi98.gitbook.io/aws-gwlb/
