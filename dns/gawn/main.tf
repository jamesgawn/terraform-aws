variable "ana-host-ipv4" {
  type = list(string)
}

variable "ana-host-ipv6" {
  type = list(string)
}

variable "domain" {
  type = string
}

variable "googleauthkey" {
  type = string
}

variable "googleauthvalue" {
  type = string
}

resource "aws_route53_zone" "gawn" {
  name = var.domain
}

output "zone_id" {
  value = aws_route53_zone.gawn.zone_id
}

output "zone_name" {
  value = aws_route53_zone.gawn.name
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.gawn.zone_id
  name    = aws_route53_zone.gawn.name
  type    = "MX"
  ttl     = "300"
  records = [
    "30 aspmx5.googlemail.com",
    "30 aspmx2.googlemail.com",
    "30 aspmx3.googlemail.com",
    "30 aspmx4.googlemail.com",
    "20 alt1.aspmx.l.google.com",
    "10 aspmx.l.google.com",
    "20 alt2.aspmx.l.google.com",
  ]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.gawn.zone_id
  name    = aws_route53_zone.gawn.name
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}

resource "aws_route53_record" "googledomainkey-txt" {
  zone_id = aws_route53_zone.gawn.zone_id
  name    = "${var.googleauthkey}.${aws_route53_zone.gawn.name}"
  type    = "TXT"
  ttl     = "300"
  records = [
    var.googleauthvalue
  ]
}

module "ana" {
  source = "../../modules/dns/dualstackrecord"

  zone_id = aws_route53_zone.gawn.zone_id
  name = "ana.${aws_route53_zone.gawn.name}"
  a-records = var.ana-host-ipv4
  aaaa-records = var.ana-host-ipv6
}

module "vpn" {
  source = "../../modules/dns/dualstackrecord"

  zone_id = aws_route53_zone.gawn.zone_id
  name = "vpn.${aws_route53_zone.gawn.name}"
  a-records = var.ana-host-ipv4
  aaaa-records = var.ana-host-ipv6
}

module "wildcard" {
  source = "../../modules/dns/dualstackaliasrecord"

  zone_id = aws_route53_zone.gawn.zone_id
  name = "*.${aws_route53_zone.gawn.name}"
  alias-target = "ana.${aws_route53_zone.gawn.name}"
  alias-hosted-zone-id = module.ana.zone_id
}