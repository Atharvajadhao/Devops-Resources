variable "image_id" {
	type 		= string
	description 	= "Image Id of the instance"
}

variable "instance_subnetId"{
	type		= string
	description	= "Subnet Id where the instance will be created"
}

resource "aws_security_group" "mySecurityGroup_1"{
	name 		= "my-Security-Group-1"
	description 	= "This is a sample security group for the sample instance"
	vpc_id 		= "vpc-0746efe0010e45be5"
	ingress {
		from_port 	= 22
		to_port 	= 22
		protocol 	= "tcp"
		cidr_blocks 	= ["0.0.0.0/0"]
	}
	egress {
		from_port	= 0
		to_port 	= 0
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	tags 		= {
		Name = "my-Security-Group-1"
	}
}


resource "aws_instance" "newInstance" {
	ami           = var.image_id
  	instance_type = "t2.micro"
	key_name = "NewKeyPair"
  	subnet_id = var.instance_subnetId
  	tags = {
  		Name = "myInstance"
	}

	vpc_security_group_ids = [aws_security_group.mySecurityGroup_1.id]
}
