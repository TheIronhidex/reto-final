output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = try(aws_instance.testInstance.1.public_ip, aws_instance.testInstance.2.public_ip, "")
}
