#vpc variable inputs
vpc_name       = "my-vpc-01"
vpc_cidr_block = "192.168.0.0/16"
#subnet variable inputs
public_subnet_cidrs  = [{ cidr_block = "192.168.1.0/24", az = "ap-south-1a" }, { cidr_block = "192.168.2.0/24", az = "ap-south-1b" }]