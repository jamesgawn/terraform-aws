variable "ana-host-ipv4" {
  type = list(string)
}

variable "ana-host-ipv6" {
  type = list(string)
}

variable "domain" {
  type = string
}

resource "aws_route53_zone" "sb" {
  name = var.domain
}

output "zone_id" {
  value = aws_route53_zone.sb.zone_id
}

output "zone_name" {
  value = aws_route53_zone.sb.name
}

module "root" {
  source = "../../modules/dns/dualstackrecord"

  zone_id = aws_route53_zone.sb.zone_id
  name = aws_route53_zone.sb.name
  a-records = var.ana-host-ipv4
  aaaa-records = var.ana-host-ipv6
}

module "www" {
  source = "../../modules/dns/dualstackrecord"

  zone_id = aws_route53_zone.sb.zone_id
  name = "www.${aws_route53_zone.sb.name}"
  a-records = var.ana-host-ipv4
  aaaa-records = var.ana-host-ipv6
}

module "filehost" {
  source = "../../modules/dns/dualstackrecord"

  zone_id = aws_route53_zone.sb.zone_id
  name = "filehost.${aws_route53_zone.sb.name}"
  a-records = var.ana-host-ipv4
  aaaa-records = var.ana-host-ipv6
}

resource "aws_route53_record" "gawn-uk-home-cca" {
  zone_id = aws_route53_zone.sb.zone_id
  name = aws_route53_zone.sb.name
  type = "CAA"
  ttl = "600"
  records = ["0 issue \"letsencrypt.org\"", "0 issue \"amazon.com\""]
}
