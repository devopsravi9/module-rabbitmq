resource "aws_route53_record" "www" {
  zone_id = var.PRIVATE_ZONE_ID
  name    = "${var.ENV}-rabbitmq"
  type    = "A"
  ttl     = 30
  records = [aws_spot_instance_request.main.private_ip]
}