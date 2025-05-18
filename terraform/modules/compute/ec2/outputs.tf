output "ec2_instance_ids" {
  value = [for i in aws_instance.ecs_instance : i.id]
}

output "instance_names" {
  value = [for i in aws_instance.ecs_instance : i.tags["Name"]]
}



output "tags" {
  value = {
    for i in aws_instance.ecs_instance :
    i.id => i.tags
  }
}
