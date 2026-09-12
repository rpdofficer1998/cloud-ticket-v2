resource "aws_vpc" "cloudticket" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cloudticket-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.cloudticket.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cloudticket-public-subnet"
  }
}

resource "aws_internet_gateway" "cloudticket" {
  vpc_id = aws_vpc.cloudticket.id

  tags = {
    Name = "cloudticket-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudticket.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudticket.id
  }

  tags = {
    Name = "cloudticket-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}