output "public_ip" {
  description = "The public IP address assigned to the app server, if applicable."
  value       = split(",", "${formatlist("%s, %s", aws_instance.app.public_ip, aws_instance.web.public_ip)}")
}
