#Vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "wahaj-vpc-${terraform.workspace}"
  }
}

# public subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "PublicSubnet-${count.index + 1}-${terraform.workspace}"
  }
}

# private subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "PrivateSubnet-${count.index + 1}-${terraform.workspace}"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPC IGW-${terraform.workspace}"
  }
}

#public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicSubnetRT-${terraform.workspace}"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt-association" {
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# elastic Ip
resource "aws_eip" "nat" {
  vpc = true
}

# nat gatway 
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    Name = "${terraform.workspace}-nat-gw"
  }
}

# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${terraform.workspace}-private-rt"
  }
}

# private route table associations
resource "aws_route_table_association" "private-rt-association" {
  count          = length(var.private_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}