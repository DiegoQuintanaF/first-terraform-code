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
