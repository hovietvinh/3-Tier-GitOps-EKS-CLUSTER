variable "env" {
  type = string
}

variable "project_name" {
  type    = string
  default = null
}

variable "namespace" {
  type = string
}
variable "service_account_name" {
  type = string
}

variable "role_name_override" {
  type    = string
  default = null
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type        = string
}

variable "policy_arns" {
  type    = map(string)
  default = {}
}