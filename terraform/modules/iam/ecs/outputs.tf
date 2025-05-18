output "instance_role_name" {
  value = aws_iam_instance_profile.ecs_profile.name
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ecs_profile.name
}

output "iam_policy_attachment_info" {
  value = {
    role       = aws_iam_role_policy_attachment.ecs_attach.role
    policy_arn = aws_iam_role_policy_attachment.ecs_attach.policy_arn
  }
}