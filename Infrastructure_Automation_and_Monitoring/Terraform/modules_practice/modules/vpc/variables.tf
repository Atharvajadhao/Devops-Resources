variable "myVpcCidrBlcok" {
  type = string
  description = "Cidr block for vpc. Default is 10.0.0.0/16"
  default = "10.0.0.0/16"
}
variable "vpcName" {
    type = string
    description = "Name of your VPC"
}