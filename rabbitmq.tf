resource "aws_spot_instance_request" "main" {
  ami                  = data.aws_ami.main.image_id
  spot_price           = data.aws_ec2_spot_price.main.spot_price
  instance_type        = var.RABBITMQ_INSTANCE_CLASS
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = var.PRIVATE_SUBNET_ID[0]

  tags = {
    Name = local.TAG_PREFIX
  }
}

resource "aws_ec2_tag" "main" {
  resource_id = aws_spot_instance_request.main.spot_instance_id
  key         = "Name"
  value       = local.TAG_PREFIX
}