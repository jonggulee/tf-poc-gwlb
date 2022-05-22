#!/bin/bash

# Set localtime
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Webpage configuration
yum install -y httpd
systemctl start httpd
systemctl enable httpd
chown -R $USER:$USER /var/www
touch /var/www/html/index.html
echo "<h1>Gateway Load Balancer Test:</h1>" >> /var/www/html/index.html
echo "<html><h2>My Private IP is: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4/)</h2></html>" >> /var/www/html/index.html
echo "<html><h2>My Host Name is: $(curl -s http://169.254.169.254/latest/meta-data/hostname/)</h2></html>" >> /var/www/html/index.html 
echo "<html><h2>My instance-id is: $(curl -s http://169.254.169.254/latest/meta-data/instance-id/)</h2></html>" >> /var/www/html/index.html 
echo "<html><h2>My instance-type is: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</h2></html>" >> /var/www/html/index.html 
echo "<html><h2>My placement/availability-zone is: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</h2></html>" >> /var/www/html/index.html 
systemctl restart httpd