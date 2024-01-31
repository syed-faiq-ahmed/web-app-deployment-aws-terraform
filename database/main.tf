#RDS
resource "aws_db_instance" "sa_rds" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "sa"
  password               = "mysqlmaster"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.sa_subnet_group.name
  vpc_security_group_ids = ["${aws_security_group.sa_rds_sg.id}"]
  skip_final_snapshot    = true
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../infrastructure/terraform.tfstate"
  }
}


data "aws_vpc" "sa_vpc" {

  filter {
    name   = "tag:Name"
    values = ["VPC"]
  }

}

data "aws_subnet" "sa_public_subnet" {

  filter {
    name   = "tag:Name"
    values = ["PUBLIC-SUBNET"]
  }

}

data "aws_subnet" "sa_private_subnet" {

  filter {
    name   = "tag:Name"
    values = ["PRIVATE-SUBNET"]
  }

}

#Subnet Group
resource "aws_db_subnet_group" "sa_subnet_group" {
  name = "sa-rds-sg"
  subnet_ids = ["${data.aws_subnet.sa_public_subnet.id}",
  "${data.aws_subnet.sa_private_subnet.id}"]

  tags = {
    Name = "DB subnet group"
  }
}

#Security Group
resource "aws_security_group" "sa_rds_sg" {
  name        = "sa RDS"
  description = "RDS Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS SECURITY GROUP"
  }
}