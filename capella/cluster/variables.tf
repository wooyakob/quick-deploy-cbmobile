variable "auth_token" {
  description = "Authentication API Key"
  sensitive   = true
}

variable "organization_id" {
  description = "Capella Organization ID"
}

variable "project_id" {
  description = "Project ID for Project Created via Terraform"
}

variable "cloud_provider" {
  description = "Cloud Provider details useful for cluster creation"

  type = object({
    name   = string
    region = string
    cidr   = string
  })
}

variable "couchbase_server" {
  description = "Couchbase Server version configuration"

  type = object({
    version = string
  })
}

variable "cluster" {
  description = "Cluster node compute and sizing configuration"

  type = object({
    num_of_nodes = optional(number, 3)
    cpu          = optional(number, 4)
    ram          = optional(number, 16)
    storage      = optional(number, 50)
  })

  default = {}
}