terraform {
  required_version = ">=0.11,<0.12"
}


provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "gitlab" {
  name         = "gitlab"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["http-server", "https-server"]
  allow_stopping_for_update = true
  
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size = "50"
    }
  }

  network_interface {
    network = "default"

    access_config {      
    }
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {    
      source      = "docker-compose.yml"
      destination = "/tmp/docker-compose.yml"
    }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs",
    "sed -i 's/<YOUR-VM-IP>/${self.network_interface.0.access_config.0.nat_ip}/' /tmp/docker-compose.yml",
    "sudo mv /tmp/docker-compose.yml /srv/gitlab/docker-compose.yml"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u appuser -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} ../ansible/playbooks/base.yml"
    environment = {
      ANSIBLE_ROLES_PATH = "../ansible/roles"
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
  
  provisioner "remote-exec" {
    inline = ["cd /srv/gitlab",
    "docker-compose up -d"]
  }
}


