module "iam_ecs" {
  source      = "../modules/iam/ecs"
  environment = var.environment
}

module "ecs_sg" {
  source      = "../modules/networking/security_groups/ecs"
  environment = var.environment
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ecs_cluster" {
  source       = "../modules/container/ecs"
  cluster_name = var.cluster_name
  environment  = var.environment
}

module "ecs_instances" {
  source               = "../modules/compute/ec2"
  environment          = var.environment
  ec2_instance_list    = var.ec2_instances
  subnet_id_map        = var.subnet_map
  iam_instance_role    = module.iam_ecs.instance_role_name
  security_group_ids   = [module.ecs_sg.security_group_id]
  key_name             = var.key_name
  cluster_name         = var.cluster_name
}
