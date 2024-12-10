variable "namespaces_policies" {
  type = list(object({
    front_namespace  = string
    back_namespace   = string
    allow_back_hosts = optional(list(string), [])
  }))
}

variable "namespaces" {
  description = "List of namespaces with their names and automount_service_account status."
  type = map(object({
    disable_automount_service_account = optional(bool, true)
    create_environments               = optional(bool, true) 
    create_segregated                 = optional(bool, true) 
  }))
  validation {
    condition     = length(var.namespaces) > 0
    error_message = "At least one namespace must be provided."
  }
}


variable "policies" {
  type = map(object({
    name   = string
    policy = string
    api_groups = optional(string, "[]")
    kinds = optional(string, "[\"Pod\"]")
  }))
}

variable "helm_charts" {
  description = "List of Helm charts to be installed."
  type = list(object({
    name        = string
    repository  = string
    namespace   = string
    chart       = string
    version     = string
    values_file = string
    create_namespace = optional(string, true)
  }))
  validation {
    condition     = length(var.helm_charts) > 0
    error_message = "You must specify at least one Helm chart."
  }
}
