variable "cluster_name" {
  description = "Cluster name"
}
variable "service_name" {
  description = "ECS Service name"
}
variable "task_name" {
  description = "Task name"
}
variable "ecr_repository_url" {
  description = "ECR Repository url"
}
variable "app_port" {
  description = "Container running port"
}
variable "desired_count" {}
variable "ecs_subnets_ids" {
  type = list(string)
}
variable "service_security_group_id" {

}

variable "task_policy_arn" {
  
}