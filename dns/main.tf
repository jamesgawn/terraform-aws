variable "ana-host-ipv4" {
  type = list(string)
}

variable "ana-host-ipv6" {
  type = list(string)
}

module "sb-com" {
  source = "./scary-biscuits"

  domain = "scary-biscuits.com"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "sb-co-uk" {
  source = "./scary-biscuits"

  domain = "scary-biscuits.co.uk"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "gawn-uk" {
  source = "./gawn"

  domain = "gawn.uk"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

module "gawn-co-uk" {
  source = "./gawn"

  domain = "gawn.co.uk"
  ana-host-ipv4 = var.ana-host-ipv4
  ana-host-ipv6 = var.ana-host-ipv6
}

resource "aws_route53_record" "gawn-uk-opera" {
  zone_id = module.gawn-uk.zone_id
  name = "opera.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["domains.tumblr.com"]
}

resource "aws_route53_record" "gawn-uk-tumblr" {
  zone_id = module.gawn-uk.zone_id
  name = "tumblr.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["domains.tumblr.com"]
}

resource "aws_route53_record" "gawn-uk-learning" {
  zone_id = module.gawn-uk.zone_id
  name = "learning.${module.gawn-uk.zone_name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["jamesgawn.github.io"]
}
