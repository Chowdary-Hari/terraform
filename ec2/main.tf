resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = var.common_tags

}

# output "ami_id" {
#   value = data.aws_ami.ami.id
# }
#
# output "security_group_name" {
#   value = data.aws_security_group.sg.id
# }
