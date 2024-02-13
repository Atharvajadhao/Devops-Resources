#Main vpc variables
variable "vpcCidrBlock" {
  type = string
  description = "Cidr block of the vpc. Default is 10.0.0.0/16"
  default = "10.0.0.0/16"
}
variable "vpcName" {
  type = string
  description = "Name of the VPC"
}

# Main public subnet variables
variable "publicSubnetVars" {
  type = list(string)
  description = "List of Cidr blocks for public subnets"
}

# Main private subnet variables
variable "privateSubnetVars" {
  type = list(string)
  description = "List of Cidr blocks for private subnets"
}