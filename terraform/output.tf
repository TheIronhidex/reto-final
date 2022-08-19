output "public_ip_app" {
  description = "The public IP address assigned to the app server, if applicable."
  value       = try(aws_instance.app_server.public_ip, "")
}
output "public_ip_web" {
  description = "The public IP address assigned to the app server, if applicable."
  value       = try(aws_instance.web_server.public_ip, "")
}
