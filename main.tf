#VPC
resource "aws_vpc" "sa_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}


#Internet Gateway 
resource "aws_internet_gateway" "sa_igw" {
  vpc_id = aws_vpc.sa_vpc.id

  tags = {
    Name = "INTERNET-GATEWAY"
  }
}


#Public Subnet
resource "aws_subnet" "sa_public_subnet" {
  vpc_id            = aws_vpc.sa_vpc.id
  cidr_block        = var.public_cidr_block
  availability_zone = var.avail_zone_1a


  tags = {
    Name = "PUBLIC-SUBNET"
  }
}

#Public2 Subnet
resource "aws_subnet" "sa_public_subnet_2" {
  vpc_id            = aws_vpc.sa_vpc.id
  cidr_block        = var.public_cidr_block_2
  availability_zone = var.avail_zone_1b


  tags = {
    Name = "PUBLIC-SUBNET-2"
  }
}



#Private Subnet
resource "aws_subnet" "sa_private_subnet" {
  vpc_id            = aws_vpc.sa_vpc.id
  cidr_block        = var.private_cidr_block
  availability_zone = var.avail_zone_1b

  tags = {
    Name = "PRIVATE-SUBNET"
  }
}


#Route Table
resource "aws_route_table" "sa_route_table" {
  vpc_id = aws_vpc.sa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sa_igw.id
  }

  tags = {
    Name = "ROUTE-TABLE"
  }
}


#Route Table Subnet Association
resource "aws_route_table_association" "sa_rt_association" {
  subnet_id      = aws_subnet.sa_public_subnet.id
  route_table_id = aws_route_table.sa_route_table.id
}

#Route Table Subnet Association
resource "aws_route_table_association" "sa_rt_association2" {
  subnet_id      = aws_subnet.sa_public_subnet_2.id
  route_table_id = aws_route_table.sa_route_table.id
}