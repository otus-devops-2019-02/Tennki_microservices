output "awx_external_ip" {
  value = "${google_compute_instance.awx.network_interface.0.access_config.0.nat_ip}"
}

