resource "aws_instance" "ecs_instance" {
  for_each = { for inst in var.ec2_instance_list : inst.name => inst }

  ami                    = each.value.ami_id
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_id_map[each.value.subnet_key]
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_role

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  cluster_name = var.cluster_name,
  ecs_enabled  = each.value.ecs_enabled,
  project_tags = join(",", each.value.project_tags),
  fsx_address  = each.value.fsx_address,
  mount_point  = each.value.mount_point
}))


  tags = {
    Name        = each.key
    Project     = join(",", each.value.project_tags)
    Environment = var.environment
  }
}
