terraform {
  required_version = ">=0.11,<0.12"
}


provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "awx" {
  name         = "awx"
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
      size = "10"
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

  provisioner "remote-exec" {
    inline = ["echo"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u appuser -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} ../ansible/playbooks/awx.yml"
    environment = {
      ANSIBLE_ROLES_PATH = "../ansible/roles"
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
  

}


