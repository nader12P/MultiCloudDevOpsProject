# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_instance" "main_ec2" {
  ami                     = "ami-0fe630eb857a6ec83"
  instance_type           = var.instance_type
  key_name = var.key_name
  subnet_id  =  var.pub_sub_id
  security_groups = [var.pub_sg_id]

  tags = {
    Name = "main_ec2"
  }
}