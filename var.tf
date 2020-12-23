variable "vpc" {
  type = object({
    private_subnet = list(string)
    public_subnet  = list(string)
    cidr           = string
  })
}

variable "master" {
  type = object({
    key_name       = string
    instance_type  = string
    name           = string
    tag            = string
  })
}

variable "worker" {
  type = object({
    key_name       = string
    instance_type  = string
    name           = string
    tag            = string
  })
}
variable "masterloadbalancer" {
  type        = object({
    load_balancer_type      = string
    loadbalancer_name       = string
    internal_loadbalancer   = bool
    target_group_name       = string
    target_group_port       = number
    target_group_protocol   = string
    alb_listener_port       = string
    alb_listener_protocol   = string
    tag                     = string
    })
}
variable "workerloadbalancer" {
  type        = object({
    load_balancer_type      = string
    loadbalancer_name       = string
    internal_loadbalancer   = bool
    target_group_name       = string
    target_group_port       = number
    target_group_protocol   = string
    alb_listener_port       = string
    alb_listener_protocol   = string
    tag                     = string
    })
}