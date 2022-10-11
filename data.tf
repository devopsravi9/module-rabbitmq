data "aws_ami" "main" {
  most_recent      = true
  name_regex       = "base-with-ansible"
  owners           = ["self"]
}

data "aws_ec2_spot_price" "main" {
  instance_type     = var.RABBITMQ_INSTANCE_CLASS
  availability_zone = data.aws_subnet.main.availability_zone

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}

data "aws_subnet" "main" {
  id = var.PRIVATE_SUBNET_ID[0]
}
