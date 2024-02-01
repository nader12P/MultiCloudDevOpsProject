resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "examplegw"
  }
}

resource "aws_route_table_association" "rt_public" {
  subnet_id      = var.pub_sub_id
  route_table_id = aws_route_table.example.id
}