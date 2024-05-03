variable "project_id" {
  type = string
}

variable "invoker_service_account_id" {
  type = string
}

variable "region" {
  description = "gateway region"
  type        = string
  default     = "europe-west1"
}

