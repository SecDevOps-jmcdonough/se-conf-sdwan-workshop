variable "resource_group_location" {
  description = "Resource Group Location"
}

variable "student" {
}

variable "username" {
}

variable "password" {
}

variable "project" {
}

variable "event" {
}

variable "rg_exists" {
  description = "Does the Resource Group already exist?"
}

variable "enable_module_output" {
  description = "Enable output from modules"
  type        = bool
  default     = true
}