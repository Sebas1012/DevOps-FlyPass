resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Name = var.vpc_name })
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  map_public_ip_on_launch = true
  tags              = merge(var.tags, { Name = "public-${each.key}" })
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id    = aws_vpc.main.id
  cidr_block = each.value
  tags      = merge(var.tags, { Name = "private-${each.key}" })
}