output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = [try(aws_instance.testInstance01.public_ip), try(aws_instance.testInstance02.public_ip)]
}
