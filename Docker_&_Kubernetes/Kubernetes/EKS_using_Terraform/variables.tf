#vpc variables
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block to be given to the vpc. Default -> 10.0.0.0/16"
  default     = "10.0.0.0/16"
}
variable "vpc_name" {
  type        = string
  description = "The name tag of the vpc"
}

#subnet varaibles
variable "public_subnet_cidrs" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
  description = "Input the list of cidr blocks for the public subnets"
  default     = []
}

