output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_iam_role_name" {
  value = module.iam_ecs.instance_role_name
}

output "ecs_security_group_id" {
  value = module.ecs_sg.security_group_id
}

/*output "ecs_ec2_instance_names" {
  value = [for inst in module.ecs_instances : inst.tags["Name"]]
}*/

output "ecs_ec2_instance_names" {
  value = module.ecs_instances.instance_names
}


output "ecs_security_group_name" {
  value = module.ecs_sg.security_group_name
}



output "ecs_iam_instance_profile_name" {
  value = module.iam_ecs.iam_instance_profile_name
}

output "ecs_iam_role_policy_attachment" {
  value = module.iam_ecs.iam_policy_attachment_info
}