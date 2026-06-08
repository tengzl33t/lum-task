resource "aws_security_group" "healthcheck_sg" {
  name   = "${var.environment}-healthcheck-sg"
  description = "Allow outbound traffic"
  vpc_id = aws_vpc.healthcheck_vpc.id

  # trivy:ignore:AWS-0104
  egress {
    description = "Egress for traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# trivy:ignore:AWS-0178

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.healthcheck_vpc.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.healthcheck_route_table.id
  ]
}

resource "aws_vpc" "healthcheck_vpc" {
  cidr_block           = "10.1.1.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "healthcheck_internet_gateway" {
  vpc_id = aws_vpc.healthcheck_vpc.id
}

resource "aws_route_table" "healthcheck_route_table" {
  vpc_id = aws_vpc.healthcheck_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.healthcheck_internet_gateway.id
  }
}

resource "aws_subnet" "healthcheck_subnet" {
  vpc_id            = aws_vpc.healthcheck_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = var.az_names[0]
}

resource "aws_route_table_association" "healthcheck_rt_association" {
  subnet_id      = aws_subnet.healthcheck_subnet.id
  route_table_id = aws_route_table.healthcheck_route_table.id
}