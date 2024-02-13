output "myVPC01_ID" {
  value = aws_vpc.myVPC01.id
}

output "myPublicSubnet" {
  value = [for subnet in aws_subnet.myPublicSubnet : "${subnet.tags.Name}: ${subnet.id}"]
}

output "cluster-endpoint-endpoint" {
  value = aws_eks_cluster.my-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-cluster.certificate_authority[0].data
}

