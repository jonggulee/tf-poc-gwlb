# output "appliance_bastion_public_ip" {
#     value = aws_instance.appliance-bastion-pub-2c.public_ip
# }

output "sec_bastion_public_ip" {
    value = aws_instance.sec-bastion-pub-2c.public_ip
}

output "Appliance_01_private_ip" {
    value = aws_instance.appliance-01-pub-2a.private_ip
}

output "Appliance_02_private_ip" {
    value = aws_instance.appliance-02-pub-2c.private_ip
}

output "app01_web_01_private_ip" {
    value = aws_instance.app01-web-01-pri-2a.private_ip
}

output "app01_web_02_private_ip" {
    value = aws_instance.app01-web-02-pri-2c.private_ip
}

