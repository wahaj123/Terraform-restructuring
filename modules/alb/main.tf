resource "aws_lb" "alb" {
  name               = "${var.loadbalancer_name}-${terraform.workspace}"
  internal           = var.internal_loadbalancer
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_groups.id]
  subnets            = var.subnets
  tags = {
    Name = "${var.loadbalancer_name}-${terraform.workspace}"
  }
}
resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.target_group_name}-${terraform.workspace}"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}