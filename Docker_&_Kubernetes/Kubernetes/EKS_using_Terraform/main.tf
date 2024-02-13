#-----------------------------------VPC and Subnets Configuration----------------------------------
#making vpc
resource "aws_vpc" "myVPC01" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

#making 2 public subnets
resource "aws_subnet" "myPublicSubnet" {
  vpc_id            = aws_vpc.myVPC01.id
  count             = length(var.public_subnet_cidrs)
  cidr_block        = var.public_subnet_cidrs[count.index].cidr_block
  availability_zone = var.public_subnet_cidrs[count.index].az
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
  map_public_ip_on_launch = true
}

#creating Internet Gateway attached to the vpc
resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myVPC01.id
  tags = {
    Name = "my-igw"
  }
}

#creating public route tables
resource "aws_route_table" "myPublicRT" {
  vpc_id = aws_vpc.myVPC01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIgw.id
  }
  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "my-public-route-table-1"
  }
}
#associate public RT to public subnets
resource "aws_route_table_association" "publicRTAssociation" {
  count          = length(aws_subnet.myPublicSubnet)
  subnet_id      = aws_subnet.myPublicSubnet[count.index].id
  route_table_id = aws_route_table.myPublicRT.id
}


#--------------------------EKS Cluster Configuration---------------------------
resource "aws_iam_role" "eks-cluster-role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks-policy-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-vpc-policy-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}


resource "aws_eks_cluster" "my-cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = [for subnet in aws_subnet.myPublicSubnet : subnet.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-policy-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-vpc-policy-AmazonEKSVPCResourceController,
  ]
}

#---------------------------------------Creating Node group for eks---------------------------------------
#IAM Role for EKS Node Group
#Creating Role
resource "aws_iam_role" "eks-node-group-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

#Attaching required policies to the role
resource "aws_iam_role_policy_attachment" "eks-workerNode-policy-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "eks-workerNode-policy-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}
resource "aws_iam_role_policy_attachment" "eks-workerNode-policy-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}

#Creating node group
resource "aws_eks_node_group" "my-node-group-1" {
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = "my-node-group-1"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = [aws_subnet.myPublicSubnet[0].id]
  version = aws_eks_cluster.my-cluster.version

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  remote_access {
    ec2_ssh_key = "newKey2"
  }
  disk_size = 20
  instance_types = ["t2.medium"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-workerNode-policy-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-workerNode-policy-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-workerNode-policy-AmazonEKS_CNI_Policy,
  ]
}
