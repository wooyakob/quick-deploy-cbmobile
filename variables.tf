variable "auth_token" {
  description = "Authentication API Key"
  sensitive   = true
}

variable "organization_id" {
  description = "Capella Organization ID"
}

variable "project_id" {
  description = "Capella Project ID"
}

variable "cloud_provider" {
  description = "Cloud Provider configuration"
}

variable "cluster" {
  description = "Cluster node compute and sizing configuration"
  default     = {}
}

variable "couchbase_server" {
  description = "Couchbase Server configuration"
}

variable "bucket" {
  description = "Bucket configuration"
}

variable "scopes" {
  description = "Scopes configuration"
}

variable "collections" {
  description = "Collections configuration"
}

variable "app_service" {
  description = "App Service configuration"
}

variable "endpoints" {
  description = "App Endpoints configuration"
}

variable "db_credential" {
  description = "Database credential configuration"
}

variable "allowed_cidr" {
  description = "CIDR block to allow cluster access for cbimport (e.g. 203.0.113.5/32)"
}
