variable "vpc"{}
variable "tag" {}
variable "ingress_rule_list" {
  description = "List of security group ingress rules"
  default     = []
  type = list(object({
    source_security_group_id = string
    cidr_blocks              = list(string),
    description              = string,
    from_port                = number,
    protocol                 = string,
    to_port                  = number
  }))
}
variable "egress_rule_list" {
  description = "List of security group egress rules"
  default = [
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"],
      description              = "Default egress rule",
      from_port                = 0,
      protocol                 = "all",
      to_port                  = 65535
    }
  ]
  type = list(object({
    source_security_group_id = string
    cidr_blocks              = list(string),
    description              = string,
    from_port                = number,
    protocol                 = string,
    to_port                  = number
  }))
}