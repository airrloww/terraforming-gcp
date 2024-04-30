variable "project_id" {
  description = "The ID of the google cloud platform project"
  type        = string
  default     = "" # project-id
}

variable "region" {
  description = "the region where resources will be deployed"
  type        = string
  default     = "eu-north1" # region
}