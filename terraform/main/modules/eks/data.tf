data "aws_vpc" "this" {
  filter {
    name   = "tag:Project"
    values = ["vpc-3tiers"]
  }
  filter {
    name   = "tag:Environment"
    values = ["dev"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public-subnet-*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-subnet-*"]
  }
}