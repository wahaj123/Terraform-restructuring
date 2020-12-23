resource "aws_security_group" "alb" {
  name        = "${var.tag}-${terraform.workspace}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc.id
    tags = {
    Name = "${var.tag}-${terraform.workspace}-sg"
  }
}

resource "aws_security_group_rule" "default_ingress_rules" {
  count                    = length(var.ingress_rule_list)
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.ingress_rule_list[count.index].source_security_group_id
  cidr_blocks              = var.ingress_rule_list[count.index].cidr_blocks
  description              = var.ingress_rule_list[count.index].description
  from_port                = var.ingress_rule_list[count.index].from_port
  protocol                 = var.ingress_rule_list[count.index].protocol
  to_port                  = var.ingress_rule_list[count.index].to_port
  type                     = "ingress"
}

resource "aws_security_group_rule" "default_egress_rules" {
  count                    = length(var.egress_rule_list)
  source_security_group_id = var.egress_rule_list[count.index].source_security_group_id
  security_group_id        = aws_security_group.alb.id
  cidr_blocks              = var.egress_rule_list[count.index].cidr_blocks
  description              = var.egress_rule_list[count.index].description
  from_port                = var.egress_rule_list[count.index].from_port
  protocol                 = var.egress_rule_list[count.index].protocol
  to_port                  = var.egress_rule_list[count.index].to_port
  type                     = "egress"
}