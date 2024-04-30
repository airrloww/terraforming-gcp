variable "project_id" {
  type = string
}

variable "root_password" {
  description = "db root password"
  type        = string
  default     = "pass"
}

variable "tier" {
  description = "SQL database instance machine type"
  type        = string
  default     = "db-f1-micro"
}

variable "edition" {
  description = "instance edition, can be ENTERPRISE or ENTERPRISE_PLUS"
  type        = string
  default     = "ENTERPRISE"
}

variable "availability_type" {
  description = "high availability (REGIONAL) or single zone (ZONAL)"
  type        = string
  default     = "ZONAL"
}
