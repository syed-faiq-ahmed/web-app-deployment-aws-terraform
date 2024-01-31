#Remote State
data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../infrastructure/terraform.tfstate"
  }
}

#Public Subnet 
data "aws_subnet" "sa_public_subnet" {

  filter {
    name   = "tag:Name"
    values = ["PUBLIC-SUBNET"]
  }

}

#Public Subnet 2
data "aws_subnet" "sa_public_subnet_2" {

  filter {
    name   = "tag:Name"
    values = ["PUBLIC-SUBNET-2"]
  }

}

#Data AWS Route 53 
data "aws_route53_zone" "hosted_zone" {
  zone_id = "Z06534101FN1R4GVTHPN6"
  //name         = var.domain_name
  private_zone = true

}

resource "aws_security_group" "sg" {
  name        = "sa_sg"
  description = "SG"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  ingress {
    description = "TCP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Instance Access"
  }
}

#Launch Config
resource "aws_launch_configuration" "lc" {
  name_prefix                 = "sa-lc"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  user_data                   = file("userdata.sh")
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg.id]
  key_name                    = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

#ASG
resource "aws_autoscaling_group" "sa_asg" {
  name                      = "sa-asg"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier = [data.aws_subnet.sa_public_subnet.id,
  data.aws_subnet.sa_public_subnet_2.id]
  target_group_arns = ["${aws_lb_target_group.sa_tg.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

#Security Group ALB
resource "aws_security_group" "sa_alb_sg" {
  name        = "sa ALB"
  description = "ALB Security Group"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      description = "SSH HTTP, and HTTPS"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB SECURITY GROUP"
  }
}

#Load Balancer
resource "aws_lb" "sa_alb" {
  name               = "sa-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sa_alb_sg.id]
  subnets = ["${data.aws_subnet.sa_public_subnet.id}",
  "${data.aws_subnet.sa_public_subnet_2.id}"]

  tags = {
    Name = "LOAD BALANCER"
  }
}

#Target Groups At 8080 
resource "aws_lb_target_group" "sa_tg" {
  name             = "sa-tg"
  target_type      = "instance"
  port             = 8080
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = data.terraform_remote_state.infra.outputs.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

#Listener 80 with Target Group Attached
resource "aws_lb_listener" "my_alb_listener8080" {
  load_balancer_arn = aws_lb.sa_alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    order            = 1
    target_group_arn = aws_lb_target_group.sa_tg.arn
    type             = "forward"
  }
}

#Route 53 
resource "aws_route53_record" "app2" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "A"
  #ttl     = 300

  alias {
    name                   = aws_lb.sa_alb.dns_name
    zone_id                = aws_lb.sa_alb.zone_id
    evaluate_target_health = true
  }
}