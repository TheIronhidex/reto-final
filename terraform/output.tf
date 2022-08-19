output "public_ip" {
  description = "The public IP address assigned to the app server, if applicable."
  value       = "${aws_instance.app.public_ip}\n${aws_instance.web.public_ip}"
}
