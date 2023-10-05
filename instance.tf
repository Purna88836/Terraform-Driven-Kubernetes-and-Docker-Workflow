resource "aws_instance" "instance" {
  ami             = "ami-02396cdd13e9a1257"
  instance_type   = "t2.micro"
  key_name        = "on-premises-hybrid-etl"
  vpc_security_group_ids = [aws_security_group.Security_Group_web_access.id]
  subnet_id       = aws_subnet.subnet_a.id
  tags = {
    Name = "virtual_server"
  }

  depends_on = [
    aws_subnet.subnet_a,
    aws_subnet.subnet_b,
    aws_security_group.Security_Group_web_access
  ]
}