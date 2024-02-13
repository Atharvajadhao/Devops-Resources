output "myVPCId" {
  value = module.myVPC.vpcId
}

output "myPublicSubnetIds" {
  value = [for subnet in module.myPublicSubnet : "${subnet.subnetName} = ${subnet.subnetId}"]
}

output "myPrivateSubnetIds" {
  value = [for subnet in module.myPrivateSubnet : "${subnet.subnetName} = ${subnet.subnetId}"]
}