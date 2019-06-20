terraform {
  required_version = ">=0.11,<0.12"
}


provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name     = "tf-gke-cluster"
  region   = "${var.region}"

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "tf-node-pool"
  region     = "${var.region}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1
  #т.к. у нас региональный кластер и в пуле каждой зоны должно быть node_count нод, для ускорения создания количество нод в пуле уменьшено до одного
  node_config {
    machine_type = "g1-small"

    disk_size_gb = "10"
    
    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_firewall" "firewall_nodeport" {
  name    = "allow-kube-nodeport-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}
