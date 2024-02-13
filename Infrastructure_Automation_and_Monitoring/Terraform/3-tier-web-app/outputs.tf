output "myVPC01_ID" {
  value = aws_vpc.myVPC01.id
}

output "myPublicSubnet" {
  value = [for subnet in aws_subnet.myPublicSubnet : "${subnet.tags.Name}: ${subnet.id}"]
}
output "myPrivateSubnet" {
  value = [for subnet in aws_subnet.myPrivateSubnet : "${subnet.tags.Name}: ${subnet.id}"]
}

output "db_instance_id" {
  value = aws_db_instance.myDBInstance.id
}

output "backend_instance_id" {
  value = aws_instance.backendInstance.id
}
output "frontend_instance_id" {
  value = aws_instance.frontendInstance.id
}
