output "public_ip" {
  description = "The public IP address assigned to the app server, if applicable."
  value       = values(aws_instance.app.public_ip, aws_instance.web.public_ip)  
}
