resource "aws_subnet" "pub_sub" {
  vpc_id     = var.vpc_id
  cidr_block = var.pub_sub_cidr_block
  map_public_ip_on_launch = var.map_ip

  tags = {
    Name = var.pub_sub_name
  }
}