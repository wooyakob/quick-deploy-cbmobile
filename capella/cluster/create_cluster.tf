output "cluster_id" {
  value = couchbase-capella_cluster.new_cluster.id
}

output "connection_string" {
  value = couchbase-capella_cluster.new_cluster.connection_string
}

resource "couchbase-capella_cluster" "new_cluster" {
  organization_id = var.organization_id
  project_id      = var.project_id
  name            = "simple-retail-prod"
  description     = "Capella Cluster for simple retail demo application."

  cloud_provider = {
    type   = var.cloud_provider.name
    region = var.cloud_provider.region
    cidr   = var.cloud_provider.cidr
  }

  couchbase_server = {
    version = var.couchbase_server.version
  }

  service_groups = [
    {
      node = {
        compute = {
          cpu = var.cluster.cpu
          ram = var.cluster.ram
        }
        disk = {
          storage = var.cluster.storage
          type    = "gp3"
          iops    = 3000
        }
      }
      num_of_nodes = var.cluster.num_of_nodes
      services     = ["data", "index", "query"]
    }
  ]

  availability = {
    type = "single"
  }

  support = {
    plan     = "developer pro"
    timezone = "PT"
  }
}
