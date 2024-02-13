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

variable "private_subnet_cidrs" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
  description = "Input the list of cidr blocks for the private subnets"
  default     = []
}

#database varaibles
variable "db_username" {
  type        = string
  description = "Username of the mysql db instance"
  default     = "root"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password of the mysql db instance"
}

#backend instance variables
variable "backend_instance_type" {
  type        = string
  description = "The instance type of the backend instance, Default -> t2.micro"
  default     = "t2.micro"
}
variable "backend_instance_name" {
  type        = string
  description = "Name of the backend instance"
}

#front instance variables
variable "frontend_instance_type" {
  type        = string
  description = "The instance type of the frontend instance, Default -> t2.micro"
  default     = "t2.micro"
}
variable "frontend_instance_name" {
  type        = string
  description = "Name of the frontend instance"
}