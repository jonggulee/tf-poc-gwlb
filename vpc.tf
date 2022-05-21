# SEC VPC AND SUBNET

resource "aws_vpc" "sec-vpc" {
  cidr_block			= "10.20.0.0/16"
  instance_tenancy		= "default"
  enable_dns_hostnames	= true

  tags = {
    Name = "sec-vpc"
  }
}

resource "aws_subnet" "sec-gwlb-2a" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-gwlb-2a"
  }
}

resource "aws_subnet" "sec-gwlb-2c" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.3.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-gwlb-2c"
  }
}

resource "aws_subnet" "sec-pub-2a" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.11.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-pub-2a"
  }
}

resource "aws_subnet" "sec-pub-2c" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.13.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-pub-2c"
  }
}

resource "aws_subnet" "sec-tgw-2a" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.251.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-tgw-2a"
  }
}

resource "aws_subnet" "sec-tgw-2c" {
  vpc_id     = aws_vpc.sec-vpc.id
  cidr_block = "10.20.253.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "sec-tgw-2c"
  }
}


# APPLIANCE VPC AND SUBNET

resource "aws_vpc" "appliance-vpc" {
  cidr_block			= "10.21.0.0/16"
  instance_tenancy		= "default"
  enable_dns_hostnames	= true

  tags = {
    Name = "appliance-vpc"
  }
}

resource "aws_subnet" "appliance-pub-2a" {
  vpc_id     = aws_vpc.appliance-vpc.id
  cidr_block = "10.21.11.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "appliance-pub-2a"
  }
}

resource "aws_subnet" "appliance-pub-2c" {
  vpc_id     = aws_vpc.appliance-vpc.id
  cidr_block = "10.21.13.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "appliance-pub-2c"
  }
}

# APP01 VPC AND SUBNET

resource "aws_vpc" "app01-vpc" {
  cidr_block			= "10.10.0.0/16"
  instance_tenancy		= "default"
  enable_dns_hostnames	= true

  tags = {
    Name = "app01-vpc"
  }
}

resource "aws_subnet" "app01-pri-2a" {
  vpc_id     = aws_vpc.app01-vpc.id
  cidr_block = "10.10.21.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "app01-pri-2a"
  }
}

resource "aws_subnet" "app01-pri-2c" {
  vpc_id     = aws_vpc.app01-vpc.id
  cidr_block = "10.10.23.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "app01-pri-2c"
  }
}

resource "aws_subnet" "app01-tgw-2a" {
  vpc_id     = aws_vpc.app01-vpc.id
  cidr_block = "10.10.251.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch	= true

  tags = {
    Name = "app01-tgw-2a"
  }
}

resource "aws_subnet" "app01-tgw-2c" {
  vpc_id     = aws_vpc.app01-vpc.id
  cidr_block = "10.10.253.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch	= true

  tags = {
    Name = "app01-tgw-2c"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "sec-igw" {
  vpc_id = aws_vpc.sec-vpc.id

  tags = {
    Name = "sec-igw"
  }
}

resource "aws_internet_gateway" "appliance-igw" {
  vpc_id = aws_vpc.appliance-vpc.id

  tags = {
    Name = "appliance-igw"
  }
}