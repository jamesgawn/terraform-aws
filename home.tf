resource "aws_route53_record" "gawn-uk-home" {
  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  name = "home.${data.aws_route53_zone.gawn_uk.name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["anagawn.mynetgear.com"]
}

resource "aws_ses_domain_identity" "gawn_ses_identity" {
  domain = "home.gawn.uk"
  provider = "aws.eu-west-1"
}

resource "aws_ses_domain_dkim" "gawn_ses_dkim" {
  domain = "home.gawn.uk"
  provider = "aws.eu-west-1"
}

resource "aws_route53_record" "home_verification_record" {
  name = "_amazonses.home.gawn.uk"
  type = "TXT"
  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  ttl = "600"
  records = ["${aws_ses_domain_identity.gawn_ses_identity.verification_token}"]
}

resource "aws_route53_record" "home_dkim_record" {
  name = "${element(aws_ses_domain_dkim.gawn_ses_dkim.dkim_tokens, count.index)}._domainkey.home.gawn.uk"
  type = "CNAME"
  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  count = 3
  ttl = "600"
  records = ["${element(aws_ses_domain_dkim.gawn_ses_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "gawn-uk-home-printer" {
  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  name = "printer.home.${data.aws_route53_zone.gawn_uk.name}"
  type = "A"
  ttl = "600"
  records = ["192.168.1.251"]
}

resource "aws_route53_record" "gawn-uk-home-unifi" {
  zone_id = "${data.aws_route53_zone.gawn_uk.zone_id}"
  name = "unifi.home.${data.aws_route53_zone.gawn_uk.name}"
  type    = "A"
  ttl     = "300"

  records = ["192.168.1.250"]
}