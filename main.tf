data "aws_availability_zones" "azs" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["self"]
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc.cidr
  public_subnet     = var.vpc.public_subnet
  private_subnet    = var.vpc.private_subnet
  availability_zone = data.aws_availability_zones.azs.names
}

module "alb_master_sg" {
  source = "./modules/securitygroups"
  vpc    = module.vpc.output
  tag    = var.masterloadbalancer.tag
  ingress_rule_list = [
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (80)"
      from_port                = 80
      protocol                 = "tcp"
      to_port                  = 80
    },
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (443)"
      from_port                = 443
      protocol                 = "tcp"
      to_port                  = 443
    }
  ]
}

module "alb-master" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.output.id
  security_groups       = module.alb_master_sg.output.sg
  subnets               = module.vpc.output.public_subnet
  target_group_name     = var.masterloadbalancer.target_group_name
  target_group_port     = var.masterloadbalancer.target_group_port
  target_group_protocol = var.masterloadbalancer.target_group_protocol
  alb_listener_port     = var.masterloadbalancer.alb_listener_port
  alb_listener_protocol = var.masterloadbalancer.alb_listener_protocol
  load_balancer_type    = var.masterloadbalancer.load_balancer_type
  loadbalancer_name     = var.masterloadbalancer.loadbalancer_name
  internal_loadbalancer = var.masterloadbalancer.internal_loadbalancer
}

module "master_sg" {
  source = "./modules/securitygroups"
  vpc    = module.vpc.output
  tag    = var.master.tag
  ingress_rule_list = [
    {
      source_security_group_id = module.alb_master_sg.output.id
      cidr_blocks              = null
      description              = "All Web Traffic (80)"
      from_port                = 80
      protocol                 = "tcp"
      to_port                  = 80
    },
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (443)"
      from_port                = 443
      protocol                 = "tcp"
      to_port                  = 443
    }
  ]
}

module "master_launch_conf" {
  count           = 3
  source          = "./modules/ec2fleet"
  subnets         = element(module.vpc.output.public_subnet, count.index)
  name            = "${var.master.name}-${count.index + 1}"
  key_name        = var.master.key_name
  security_groups = module.master_sg.output
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.master.instance_type
  tag             = "${var.master.tag}-${count.index + 1}"
}

module "alb_worker_sg" {
  source = "./modules/securitygroups"
  vpc    = module.vpc.output
  tag    = var.workerloadbalancer.tag
  ingress_rule_list = [
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (80)"
      from_port                = 80
      protocol                 = "tcp"
      to_port                  = 80
    },
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (443)"
      from_port                = 443
      protocol                 = "tcp"
      to_port                  = 443
    }
  ]
}

module "alb-worker" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.output.id
  security_groups       = module.alb_worker_sg.output
  subnets               = module.vpc.output.private_subnet
  target_group_name     = var.workerloadbalancer.target_group_name
  target_group_port     = var.workerloadbalancer.target_group_port
  target_group_protocol = var.workerloadbalancer.target_group_protocol
  alb_listener_port     = var.workerloadbalancer.alb_listener_port
  alb_listener_protocol = var.workerloadbalancer.alb_listener_protocol
  load_balancer_type    = var.workerloadbalancer.load_balancer_type
  loadbalancer_name     = var.workerloadbalancer.loadbalancer_name
  internal_loadbalancer = var.workerloadbalancer.internal_loadbalancer
}

module "worker_sg" {
  source = "./modules/securitygroups"
  vpc    = module.vpc.output
  tag    = var.worker.tag
  ingress_rule_list = [
    {
      source_security_group_id = module.alb_worker_sg.output.id
      cidr_blocks              = null
      description              = "All Web Traffic (80)"
      from_port                = 80
      protocol                 = "tcp"
      to_port                  = 80
    },
    {
      source_security_group_id = null
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "All Web Traffic (443)"
      from_port                = 443
      protocol                 = "tcp"
      to_port                  = 443
    }
  ]
}

module "worker_launch_conf" {
  count           = 3
  source          = "./modules/ec2fleet"
  subnets         = element(module.vpc.output.private_subnet, count.index)
  name            = "${var.worker.name}-${count.index + 1}"
  key_name        = var.worker.key_name
  security_groups = module.worker_sg.output.sg
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.worker.instance_type
  tag             = "${var.worker.tag}-${count.index + 1}"
}

