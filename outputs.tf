output "vpc_id" { value = aws_vpc.sa_vpc.id }
output "vpc_cidr_block" { value = var.vpc_cidr_block }
output "public_cidr_block" { value = var.public_cidr_block }
output "public_cidr_block_2" { value = var.public_cidr_block_2 }
output "private_cidr_block" { value = var.private_cidr_block }