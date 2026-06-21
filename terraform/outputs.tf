output "server_ip" {
  description = "Public IPv4 of the k3s server. Point your DNS A record here."
  value       = hcloud_server.k3s.ipv4_address
}
