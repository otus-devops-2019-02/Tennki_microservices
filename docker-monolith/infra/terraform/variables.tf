variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west3"
}

variable zone {
  description = "Zone"
  default     = "europe-west3-a"
}

variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the privat key used to connect to instance"
}

variable disk_image {
  description = "Disk image for reddit app"  
}

variable env {
  description = "Environment"
}

variable node_count {
  description = "Nodes count"
  default     = "1"
}
