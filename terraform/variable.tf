variable "region" {
  description = "region for launching AWS resources"
  default = "eu-west-3"
}
variable "access_key" {
  description = "AWS access key credential"
  default = "access_key"
}
variable "secret_key" {
  description = "AWS secret key credential"
  default = "secret_key"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "eu-west-3a"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-09e513e9eacab10c1"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}