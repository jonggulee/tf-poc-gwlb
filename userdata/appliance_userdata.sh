#!/bin/bash

# Set localtime
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Enable IP Forwarding:
sudo sysctl -w net.ipv4.ip_forward=1

# Environment variable configuration
curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document > /home/ec2-user/iid
export instance_interface=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export instance_vpcid=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/$instance_interface/vpc-id)
export instance_az=$(cat /home/ec2-user/iid |grep 'availability' | awk -F': ' '{print $2}' | awk -F',' '{print $1}')
export instance_ip=$(cat /home/ec2-user/iid |grep 'privateIp' | awk -F': ' '{print $2}' | awk -F',' '{print $1}' | awk -F'"' '{print$2}')
export instance_region=$(cat /home/ec2-user/iid |grep 'region' | awk -F': ' '{print $2}' | awk -F',' '{print $1}' | awk -F'"' '{print$2}')
export gwlb_ip=$(aws --region $instance_region ec2 describe-network-interfaces --filters Name=vpc-id,Values=$instance_vpcid | jq ' .NetworkInterfaces[] | select(.AvailabilityZone=='$instance_az') | select(.InterfaceType=="gateway_load_balancer") |.PrivateIpAddress' -r)

# Webpage configuration
yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chown -R $USER:$USER /var/www
touch /var/www/html/index.html
sudo echo "<h1>Gateway Load Balancer Test:</h1>" >> /var/www/html/index.html
sudo echo "<html><h2>My Public IP is: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)</h2></html>" >> /var/www/html/index.html
sudo echo "<html><h2>My Private IP is: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4/)</h2></html>" >> /var/www/html/index.html
sudo echo "<html><h2>My Host Name is: $(curl -s http://169.254.169.254/latest/meta-data/hostname/)</h2></html>" >> /var/www/html/index.html 
sudo echo "<html><h2>My instance-id is: $(curl -s http://169.254.169.254/latest/meta-data/instance-id/)</h2></html>" >> /var/www/html/index.html 
sudo echo "<html><h2>My instance-type is: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</h2></html>" >> /var/www/html/index.html 
sudo echo "<html><h2>My placement/availability-zone is: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</h2></html>" >> /var/www/html/index.html 
sudo systemctl restart httpd

# Start and configure iptables
yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables

# Configuration below allows allows all traffic
# Set the default policies for each of the built-in chains to ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Flush the nat and mangle tables, flush all chains (-F), and delete all non-default chains (-X)
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

# Configure nat table to hairpin traffic back to GWLB
sudo iptables -t nat -A PREROUTING -p udp -s $gwlb_ip -d $instance_ip -i eth0 -j DNAT --to-destination $gwlb_ip:6081
sudo iptables -t nat -A POSTROUTING -p udp --dport 6081 -s $gwlb_ip -d $gwlb_ip -o eth0 -j MASQUERADE

# Save iptables
sudo service iptables save
sudo systemctl restart iptables