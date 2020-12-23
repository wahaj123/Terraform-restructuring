#vpc
vpc = {
    cidr            =   "13.0.0.0/16"
    public_subnet   =   ["13.0.1.0/24", "13.0.2.0/24","13.0.3.0/24"]
    private_subnet  =   ["13.0.4.0/24", "13.0.5.0/24","13.0.6.0/24"]
}

#worker
worker= {
    key_name = "wahaj-nclouds"
    instance_type = "t2.micro"
    name= "education_shared_elasticsearch-shared-worker"
    tag = "master-node"
}

#master
master ={
    key_name= "wahaj-nclouds"
    instance_type= "t2.micro"
    name= "education_shared_elasticsearch-shared-master"
    tag = "worker-node"
}

#masterloadbalancer
masterloadbalancer ={
    load_balancer_type      = "application"
    loadbalancer_name       = "master-Alb"
    internal_loadbalancer   = true
    target_group_name       = "master-alb-tg"
    target_group_port       = 80
    target_group_protocol   = "HTTP"
    alb_listener_port       = "80"
    alb_listener_protocol   = "HTTP"
    tag                     = "master_alb"
}

#workerlaodbalancer
workerloadbalancer ={
    load_balancer_type      = "application"
    loadbalancer_name       = "worker-Alb"
    internal_loadbalancer   = false
    target_group_name       = "worker-tg"
    target_group_port       = 80
    target_group_protocol   = "HTTP"
    alb_listener_port       = "80"
    alb_listener_protocol   = "HTTP"
    tag                     = "worker_alb"

}

# #route53
# route53 =   {
#     route53_name                    = ""
#     route53_type                    = "A"
#     route53_evaluate_target_health  = false
#     zone_name                       = ""
#     zone_private_zone               = false 
# }
