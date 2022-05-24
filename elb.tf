# --------------------------------
# APPLIANCE GWLB
# --------------------------------
resource "aws_lb" "appliance-gwlb" {
  name               = "appliance-gwlb"
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.appliance-pub-2a.id, aws_subnet.appliance-pub-2c.id]

  tags = {
    Name = "appliance-gwlb"
  }
}

resource "aws_lb_target_group" "appliance-gwlb-tg" {
  name     = "appliance-gwlb-tg"
  port     = 6081
  protocol = "GENEVE"
  vpc_id   = aws_vpc.appliance-vpc.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "appliance-gwlb-attach-01" {
  target_group_arn = aws_lb_target_group.appliance-gwlb-tg.arn
  target_id        = aws_instance.appliance-01-pub-2a.id
  port             = 6081
  depends_on = [aws_instance.appliance-01-pub-2a]
}

resource "aws_lb_target_group_attachment" "appliance-gwlb-attach-02" {
  target_group_arn = aws_lb_target_group.appliance-gwlb-tg.arn
  target_id        = aws_instance.appliance-02-pub-2c.id
  port             = 6081
  depends_on = [aws_instance.appliance-02-pub-2c]
}

resource "aws_lb_listener" "appliance-gwlb-listener" {
  load_balancer_arn = aws_lb.appliance-gwlb.id

  default_action {
    target_group_arn = aws_lb_target_group.appliance-gwlb-tg.id
    type             = "forward"
  }
}

# --------------------------------
# APP01 ALB in GWLB VPC
# --------------------------------
resource "aws_lb" "sec-app01-web-alb" {
  name               = "sec-app01-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec-app01-web-alb-sg.id]
  subnets            = [aws_subnet.sec-pub-2a.id, aws_subnet.sec-pub-2c.id]

  tags = {
    Name = "sec-app01-web-alb"
  }
  
  depends_on = [aws_lb.app01-web-nlb]
}

resource "aws_lb_target_group" "sec-app01-web-alb-tg" {
  name        = "sec-app01-web-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.sec-vpc.id
}

resource "aws_lb_target_group_attachment" "sec-app01-web-alb-attach-01" {
  target_group_arn = aws_lb_target_group.sec-app01-web-alb-tg.arn
  target_id        = data.aws_network_interface.app01-web-nlb-private-ip-2a.private_ip
  port             = 80

  availability_zone = "all"
}


resource "aws_lb_target_group_attachment" "sec-app01-web-alb-attach-02" {
  target_group_arn = aws_lb_target_group.sec-app01-web-alb-tg.arn
  target_id        = data.aws_network_interface.app01-web-nlb-private-ip-2c.private_ip
  port             = 80

  availability_zone = "all"
}

resource "aws_lb_listener" "sec-app01-web-alb-listener" {
  load_balancer_arn = aws_lb.sec-app01-web-alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.sec-app01-web-alb-tg.id
    type             = "forward"
  }
}

# --------------------------------
# APP01 ALB in NLB VPC
# --------------------------------
resource "aws_lb" "app01-web-nlb" {
  name               = "app01-web-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.app01-pri-2a.id, aws_subnet.app01-pri-2c.id]
  
  tags = {
    Environment = "app01-web-nlb"
  }
}

resource "aws_lb_target_group" "app01-web-nlb-tg" {
  name     = "app01-web-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.app01-vpc.id
  
  tags = {
    Name = "app01-web-nlb-tg"
  }
}

resource "aws_lb_target_group_attachment" "app01-web-nlb-attach-01" {
  target_group_arn = aws_lb_target_group.app01-web-nlb-tg.arn
  target_id        = aws_instance.app01-web-01-pri-2a.id
  port             = 80
  depends_on = [aws_instance.app01-web-01-pri-2a]
}

resource "aws_lb_target_group_attachment" "app01-web-nlb-attach-02" {
  target_group_arn = aws_lb_target_group.app01-web-nlb-tg.arn
  target_id        = aws_instance.app01-web-02-pri-2c.id
  port             = 80
  depends_on = [aws_instance.app01-web-02-pri-2c]
}

resource "aws_lb_listener" "app01-web-nlb-listener" {
  load_balancer_arn = aws_lb.app01-web-nlb.id
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.app01-web-nlb-tg.id
    type             = "forward"
  }
}
