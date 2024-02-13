#vpc variable inputs
vpc_name       = "my-vpc-01"
vpc_cidr_block = "10.0.0.0/16"
#subnet variable inputs
public_subnet_cidrs  = [{ cidr_block = "10.0.1.0/24", az = "ap-south-1a" }]
private_subnet_cidrs = [{ cidr_block = "10.0.2.0/24", az = "ap-south-1b" }, { cidr_block = "10.0.3.0/24", az = "ap-south-1c" }]
#database variables inputs
db_username = "admin"
db_password = "mysql1234"
#backend instance inputs
backend_instance_type = "t2.micro"
backend_instance_name = "my-backend-instance-1"
#frontend instance inputs
frontend_instance_type = "t2.micro"
frontend_instance_name = "my-frontend-instance-1"