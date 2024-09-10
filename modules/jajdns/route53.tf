resource "aws_route53_record" "jajdns_a_record" {
  count = length(var.zone_id) > 0 ? 1 : 0

  depends_on = [var.zone_id]

  zone_id = var.zone_id
  name = "${var.subdomain}"
  type = "A"
  ttl = 300
  records = [aws_instance.jajdns_ec2_instance.public_ip]
}

resource "aws_route53_record" "jajdns_ns_record" {
    count = length(var.zone_id) > 0 ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.ns_subdomain}"
  type    = "NS"
  ttl     = 172800

  records = ["${var.subdomain}."]
}