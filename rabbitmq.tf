resource "aws_spot_instance_request" "main" {
  ami                         = data.aws_ami.main.id
  spot_price                  = data.aws_ec2_spot_price.main.spot_price
  instance_type               = var.RABBITMQ_INSTANCE_CLASS
  wait_for_fulfillment        = true
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = var.PRIVATE_SUBNET_ID[0]
  iam_instance_profile        = aws_iam_instance_profile.secrets.name

  tags = {
    Name = local.TAG_PREFIX
  }
}

resource "aws_ec2_tag" "main" {
  resource_id = aws_spot_instance_request.main.spot_instance_id
  key         = "Name"
  value       = local.TAG_PREFIX
}

resource "null_resource" "ansible" {
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
    host     = aws_spot_instance_request.main.private_ip
  }
  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/devopsravi9/roboshop-ansible.git",
      "cd ansible",
      "ansible-playbook robo.yml -e HOST=localhost -e ROLE=rabbitmq -e ENV=${var.ENV}",
    ]
  }
}