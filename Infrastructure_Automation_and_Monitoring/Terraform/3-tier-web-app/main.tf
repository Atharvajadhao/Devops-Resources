#making vpc
resource "aws_vpc" "myVPC01" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

#making public subnets
resource "aws_subnet" "myPublicSubnet" {
  vpc_id            = aws_vpc.myVPC01.id
  count             = length(var.public_subnet_cidrs)
  cidr_block        = var.public_subnet_cidrs[count.index].cidr_block
  availability_zone = var.public_subnet_cidrs[count.index].az
  tags = {
    Name = "my-new-public-subnet-${count.index + 1}"
  }
}

#making private subnets
resource "aws_subnet" "myPrivateSubnet" {
  vpc_id            = aws_vpc.myVPC01.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index].cidr_block
  availability_zone = var.private_subnet_cidrs[count.index].az
  tags = {
    Name = "my-new-private-subnet-${count.index + 1}"
  }
}

#creating Internet Gateway attached to the vpc
resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myVPC01.id
  tags = {
    Name = "my-new-igw"
  }
}

#elastic Ip for nat gateway
resource "aws_eip" "myEip1" {
  domain = "vpc"
  tags = {
    Name = "my-Eip-1"
  }
}
#Creating Nat-Gateway
resource "aws_nat_gateway" "myNatGw" {
  allocation_id = aws_eip.myEip1.id
  subnet_id     = aws_subnet.myPublicSubnet[0].id
  tags = {
    Name = "my-NGW-1"
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
    cidr_block = "10.0.0.0/16"
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

#creating private route tables
resource "aws_route_table" "myPrivateRT" {
  vpc_id = aws_vpc.myVPC01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myNatGw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    Name = "my-private-route-table-1"
  }
}
#associating private subnet to private RT
resource "aws_route_table_association" "privateRTAssociation" {
  count          = length(aws_subnet.myPrivateSubnet)
  subnet_id      = aws_subnet.myPrivateSubnet[count.index].id
  route_table_id = aws_route_table.myPrivateRT.id
}

#creating security groups for database
resource "aws_security_group" "databaseSecurityGroup" {
  name        = "database-security-group"
  description = "Security Group for database-instance"
  vpc_id      = aws_vpc.myVPC01.id
  tags = {
    Name = "database-security-group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#--------------------------------Security Groups and Instances-------------------------------
#creating security groups for backend instance
resource "aws_security_group" "backendSecurityGroup" {
  name        = "backend-security-group"
  description = "Security Group for backend-instance"
  vpc_id      = aws_vpc.myVPC01.id
  tags = {
    Name = "backend-security-group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating frontend security group
resource "aws_security_group" "frontendSecurityGroup" {
  name        = "frontend-security-group"
  description = "Security Group for frontend-instance"
  vpc_id      = aws_vpc.myVPC01.id
  tags = {
    Name = "frontend-security-group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#creating subnet groups for the db instance
resource "aws_db_subnet_group" "mySubnetGroup1" {
  name       = "my-subnet-group-1"
  subnet_ids = [for subnet in aws_subnet.myPrivateSubnet : subnet.id]
  tags = {
    Name = "mySubnetGroup-1"
  }
}
#creating DB-instance
resource "aws_db_instance" "myDBInstance" {
  allocated_storage      = 20
  db_name                = "myDbInstance"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.mySubnetGroup1.name
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.databaseSecurityGroup.id]
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  tags = {
    Name = "my-db-instance"
  }
}

#copying backend ami 
resource "aws_ami_copy" "backend_ami" {
  name              = "backendAmi"
  description       = "AMI for backend instance"
  source_ami_id     = data.aws_ami.backend_ami.id
  source_ami_region = "us-east-2"
  tags = {
    Name = "backend-ami"
  }
}
#copying frontend ami from us-east-1 region
resource "aws_ami_copy" "frontend_ami" {
  name              = "frontendAmi"
  description       = "AMI for frontend instance"
  source_ami_id     = data.aws_ami.frontend_ami.id
  source_ami_region = "us-east-2"
  tags = {
    Name = "frontend-ami"
  }
}

#creating backend instance
resource "aws_instance" "backendInstance" {
  ami             = aws_ami_copy.backend_ami.id
  instance_type   = var.backend_instance_type
  key_name        = "backendKey"
  security_groups = [aws_security_group.backendSecurityGroup.id]
  subnet_id       = aws_subnet.myPrivateSubnet[0].id
  tags = {
    Name = var.backend_instance_name
  }
}

#creating frontend instance
resource "aws_instance" "frontendInstance" {
  ami                         = aws_ami_copy.frontend_ami.id
  instance_type               = var.frontend_instance_type
  key_name                    = "frontendKey"
  security_groups             = [aws_security_group.frontendSecurityGroup.id]
  subnet_id                   = aws_subnet.myPublicSubnet[0].id
  associate_public_ip_address = true
  tags = {
    Name = var.frontend_instance_name
  }
}

#-----------------------------------Creting Load Balancers----------------------------------
#CONFIGURING NLB
#security groups for newtork load balancer
resource "aws_security_group" "nlb_sg" {
  name        = "nlbSg"
  description = "Security group for nlb"
  vpc_id      = aws_vpc.myVPC01.id
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creating network load balancer
resource "aws_lb" "backend_nlb_1" {
  name               = "backendNlb1"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = [aws_subnet.myPrivateSubnet[0].id]
  tags = {
    Name = "backend-nlb-1"
  }
}
#creating target group for backend nlb
resource "aws_lb_target_group" "backend_nlb_target_group" {
  target_type = "instance"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.myVPC01.id
  health_check {
    enabled           = true
    healthy_threshold = 2
    protocol          = "TCP"
    port              = 8000
    interval          = 60
    timeout           = 60
  }
  tags = {
    Name = "backend_nlb_target_group"
  }
}
#create a listner for nlb
resource "aws_lb_listener" "backend_nlb_1_listner" {
  load_balancer_arn = aws_lb.backend_nlb_1.arn
  port              = 8000
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_nlb_target_group.arn
  }
}
#attach instance to the target group
# resource "aws_lb_target_group_attachment" "backend_nlb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.backend_nlb_target_group.arn
#   port = 8000
#   target_id = aws_instance.backendInstance.id
# }


#-----------------------------------Creating Auto Scaler------------------------------
#creating launch template
resource "aws_launch_template" "new_Backend_LT" {
  name_prefix            = "new_Backend_LT"
  image_id               = aws_ami_copy.backend_ami.id
  instance_type          = "t2.micro"
  key_name               = "backendKey"
  vpc_security_group_ids = [aws_security_group.backendSecurityGroup.id]
  tags = {
    Name = "backend-launch-template"
  }
}
#creating ASG
resource "aws_autoscaling_group" "backendASG" {
  name                      = "backendASG"
  desired_capacity          = 1
  max_size                  = 4
  min_size                  = 1
  vpc_zone_identifier       = [aws_subnet.myPrivateSubnet[0].id]
  health_check_grace_period = 120
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.backend_nlb_target_group.arn]
  launch_template {
    id = aws_launch_template.new_Backend_LT.id
  }

}


