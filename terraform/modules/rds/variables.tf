variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "database_subnet_ids" {
  description = "Private database subnet IDs for the RDS DB subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt the RDS storage"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version for CloudTicket v2"
  type        = string
  default     = "16"
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "cloudticketv2"
}

variable "db_username" {
  description = "Master username for the PostgreSQL database"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial allocated autoscaling storage in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GiB"
  type        = number
  default     = 30
}

variable "port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}
