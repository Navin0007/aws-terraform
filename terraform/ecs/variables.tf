variable "environment" {}
variable "vpc_id" {}
variable "key_name" {}
variable "cluster_name" {}

variable "subnet_map" {
  type = map(string)
}

variable "ec2_instances" {
  description = "List of ECS EC2 instance configs"
  type = list(object({
    name           = string
    ami_id         = string
    instance_type  = string
    subnet_key     = string
    project_tags   = list(string)
    ecs_enabled    = bool
    fsx_address    = optional(string)
    mount_point    = optional(string)
  }))
}
