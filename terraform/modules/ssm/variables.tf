variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "initial_image_tag" {
  description = "Initial Docker image tag to store in Parameter Store"
  type        = string
}
