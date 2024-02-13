variable "subnetVpcId" {
  type = string
  description = "VPC id of VPC, in which subnet will be placed"
}
variable "subnetCidrBlock" {
  type = string
  description = "Cidr block for the subnet"
}
variable "mySubnetName" {
  type = string
  description = "Name of the subnet"
}