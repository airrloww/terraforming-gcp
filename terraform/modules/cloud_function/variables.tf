# function required arguments:

variable "function_runtime" {
  description = "execution runtime"
  type        = string
  default     = "python39"
}

# Optional arguments :
variable "description" {
  description = "funtion description"
  type        = string
  default     = null
}

variable "entry_point" {
  description = "Name of the function that will be executed when the Google Cloud Function is triggered"
  type        = string
  default     = "main"
}

variable "timeout" {
  description = "Timeout (in seconds) for the function. Default value is 60 seconds"
  type        = number
  default     = 60
}

variable "memory" {
  description = " Memory (in MB), default value is 256"
  type        = number
  default     = 512
}

variable "trigger_http" {
  description = "Any HTTP request to the endpoint will trigger function execution"
  type        = bool
  default     = true
}

variable "https_trigger_security_level" {
  description = "[SECURE_ALWAYS] automatically redirected to the HTTPS URL, [SECURE_OPTIONAL] succeed without redirects"
  type        = string
  default     = "SECURE_OPTIONAL"
}


variable "project_id" {
  type = string
}

variable "region" {
  type = string
}
