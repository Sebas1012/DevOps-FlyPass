resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { 
    Name = var.vpc_name 
  })
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  map_public_ip_on_launch = true

  tags              = merge(var.tags, { 
    Name = "public-${each.key}"
  })
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id    = aws_vpc.main.id
  cidr_block = each.value

  tags      = merge(var.tags, { 
    Name = "private-${each.key}",
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "internet-gateway"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, {
    Name = "public-route-table"
  })
}

resource "aws_route_table_association" "public" {
  for_each = toset(var.public_subnets)

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

