resource "aws_subnet" "mySubnet" {
  vpc_id = var.subnetVpcId
  cidr_block = var.subnetCidrBlock
  tags = {
    Name = var.mySubnetName
  }
}