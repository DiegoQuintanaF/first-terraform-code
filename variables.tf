variable "host_os" {
  type        = string
  description = "value of the host operating system ('unix' or 'windows')"
  default     = "unix"
  nullable    = false

  validation {
    condition     = var.host_os == "unix" || var.host_os == "windows"
    error_message = "The host_os value must be a valid option, exactly \"unix\" or \"windows\"."
  }
}

variable "ssh_key_path" {
  type        = string
  description = "value of the path to the ssh private key"
  default     = "~/.ssh/mtckey"
}

variable "provider_region" {
  type        = string
  description = "value of the aws region"
  default     = "us-east-1"
}

variable "provider_profile" {
  type        = string
  description = "value of the aws profile"
  default     = "default"
}

variable "instance_type" {
  type        = string
  description = "value of the aws instance type"
  default     = "t2.micro"
}
