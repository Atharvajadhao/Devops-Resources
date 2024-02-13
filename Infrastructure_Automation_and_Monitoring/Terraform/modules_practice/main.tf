#VPC
module "myVPC" {
  source = "./modules/vpc"
  myVpcCidrBlcok = var.vpcCidrBlock
  vpcName = var.vpcName
}

#Public subnet
module "myPublicSubnet" {
  source = "./modules/subnets"
  count = length(var.publicSubnetVars)
  subnetVpcId = module.myVPC.vpcId
  subnetCidrBlock = var.publicSubnetVars[count.index]
  mySubnetName = "my-public-subnet-${count.index + 1}"
}

#Private subnet
module "myPrivateSubnet" {
  source = "./modules/subnets"
  count = length(var.privateSubnetVars)
  subnetVpcId = module.myVPC.vpcId
  subnetCidrBlock = var.privateSubnetVars[count.index]
  mySubnetName = "my-private-subnet-${count.index + 1}"
}