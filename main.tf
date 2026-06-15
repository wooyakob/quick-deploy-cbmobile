terraform {
  required_providers {
    couchbase-capella = {
      source = "couchbasecloud/couchbase-capella"
    }
  }
}

provider "couchbase-capella" {
  authentication_token = var.auth_token
}

module "cluster" {
  source = "./capella/cluster"

  organization_id  = var.organization_id
  project_id       = var.project_id
  auth_token       = var.auth_token
  cloud_provider   = var.cloud_provider
  couchbase_server = var.couchbase_server
  cluster          = var.cluster
}

module "bucket" {
  source = "./capella/bucket"

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  bucket          = var.bucket
}

module "scopes" {
  source = "./capella/scopes"

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  bucket_id       = module.bucket.bucket_id
  scopes          = var.scopes
}

module "collections" {
  source = "./capella/collections"
  
  depends_on = [module.scopes]

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  bucket_id       = module.bucket.bucket_id
  scopes          = var.scopes
  collections     = var.collections
}

module "app_service" {
  source = "./mobile/app-service"

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  app_service     = var.app_service
}

module "app_endpoints" {
  source = "./mobile/app-endpoints"

  depends_on = [module.collections, module.app_service]

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  app_service_id  = module.app_service.appservice_id
  bucket_name     = var.bucket.name
  endpoints       = var.endpoints
}

module "db_credentials" {
  source = "./capella/db-credentials"

  depends_on = [module.bucket]

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  db_credential   = var.db_credential
}

module "allowed_ip" {
  source = "./capella/allowed-ip"

  depends_on = [module.cluster]

  organization_id = var.organization_id
  project_id      = var.project_id
  auth_token      = var.auth_token
  cluster_id      = module.cluster.cluster_id
  allowed_cidr    = var.allowed_cidr
}
