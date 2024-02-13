resource "aws_vpc" "myVpc" {
  cidr_block = var.myVpcCidrBlcok
  tags = {
    Name = var.vpcName
  }
}