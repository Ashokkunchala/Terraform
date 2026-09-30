variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "certificate_arn" { type = string, default = null }
variable "container_port" { type = number }

resource "aws_security_group" "this" {
  name   = "${var.name}-alb"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.certificate_arn == null ? [] : [1]
    content {
      description = "HTTPS"
      protocol = "tcp"
      from_port = 443
      to_port = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name = substr("${var.name}-alb", 0, 32)
  load_balancer_type = "application"
  internal = false
  subnets = var.public_subnets
  security_groups = [aws_security_group.this.id]
}

resource "aws_lb_target_group" "this" {
  name = substr("${var.name}-tg", 0, 32)
  port = var.container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    path = "/"
    matcher = "200-399"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  dynamic "default_action" {
    for_each = var.certificate_arn == null ? [1] : []
    content {
      type = "forward"
      target_group_arn = aws_lb_target_group.this.arn
    }
  }

  dynamic "default_action" {
    for_each = var.certificate_arn == null ? [] : [1]
    content {
      type = "redirect"
      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.certificate_arn == null ? 0 : 1
  load_balancer_arn = aws_lb.this.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = var.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

output "load_balancer_arn" { value = aws_lb.this.arn }
output "load_balancer_dns_name" { value = aws_lb.this.dns_name }
output "target_group_arn" { value = aws_lb_target_group.this.arn }
output "security_group_id" { value = aws_security_group.this.id }
