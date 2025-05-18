resource "aws_vpc" "vpc" {
  cidr_block = var.eks-vpc-cidr

  tags = {
    Name = var.eks-vpc-name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.eks-vpc-igw-name
  }
}


#Create the public subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.eks-subnet-1-cidr
  availability_zone = var.eks-subnet-1-az
  map_public_ip_on_launch = true

  tags = {
    Name = var.eks-subnet-1-name
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.eks-subnet-2-cidr
  availability_zone       = var.eks-subnet-2-az
  map_public_ip_on_launch = true

  tags = {
    Name = var.eks-subnet-2-name
  }
}


resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-1-name
  }
}

resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-2-name
  }
}


resource "aws_route_table_association" "rt-association-1" {
  route_table_id = aws_route_table.rt-1.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "rt-association-2" {
  route_table_id = aws_route_table.rt-2.id
  subnet_id      = aws_subnet.public-subnet-2.id
}


resource "aws_security_group" "sg" {
  name = "EKS-SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH-Port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP Port"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Sonaqrube Port"
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks-sg-name
  }
}