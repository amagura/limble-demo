variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Project database name"
  type        = string
  default     = "demodb"
}

variable "db_user" {
  description = "Project database user"
  type        = string
  default     = "lid"
}

variable "db_pass" {
  description = "Project database password"
  type        = string
  default     = "Lithuanian_UnknowingsHesit_ance_sAmarium"
}
