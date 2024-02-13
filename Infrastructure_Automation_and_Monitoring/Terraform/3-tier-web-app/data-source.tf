data "aws_ami" "frontend_ami" {
  # most_recent = true
  provider = aws.use-2
  owners   = ["292152202882"]
  filter {
    name   = "name"
    values = ["frontend-image"]
  }
}
data "aws_ami" "backend_ami" {
  # most_recent = true
  provider = aws.use-2
  owners   = ["292152202882"]
  filter {
    name   = "name"
    values = ["backend-image"]
  }
}

