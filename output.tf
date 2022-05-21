output "Appliance_bastion_public_ip" {
    value = aws_instance.appliance-bastion-pub-2c.public_ip
}

output "Appliance_01_private_ip" {
    value = aws_instance.appliance-01-pub-2a.private_ip
}

output "Appliance_02_private_ip" {
    value = aws_instance.appliance-02-pub-2c.private_ip
}