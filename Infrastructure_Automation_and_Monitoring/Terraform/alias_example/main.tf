resource "aws_instance" "myInstance1" {
  ami          	= "ami-0e83be366243f524a"
  provider	    = aws.aws_use2
  instance_type	= "t2.micro"
  tags  	      = {
  	Name = "myInstance-1"
  }
}

resource "aws_instance" "myInstance2" {
  ami          	= "ami-0287a05f0ef0e9d9a"
  instance_type	= "t2.micro"
  provider	    = aws.aws_aps1
  tags 		      = {
    Name    = "myInstance-2",
  }
}
