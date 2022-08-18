output "public_ip" {
    description = "The public IP address assigned to the instance, if applicable.
    value = "${join(",", aws_instance.testInstance.*.public_ip, "")}"
}
