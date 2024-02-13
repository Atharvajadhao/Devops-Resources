output "subnetId" {
  value = aws_subnet.mySubnet.id
}
output "subnetName" {
  value = aws_subnet.mySubnet.tags.Name
}