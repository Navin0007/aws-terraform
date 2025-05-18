variable "environment" {}
variable "cluster_name" {}
variable "key_name" {}
variable "iam_instance_role" {}
variable "security_group_ids" {
  type = list(string)
}
variable "subnet_id_map" {
  type = map(string)
}

variable "ec2_instance_list" {
  type = list(object({
    name           = string
    ami_id         = string
    instance_type  = string
    subnet_key     = string
    project_tags   = list(string)
    ecs_enabled    = bool
    fsx_address    = optional(string, "")    # <== add default
    mount_point    = optional(string, "")    # <== add default
  }))
}
