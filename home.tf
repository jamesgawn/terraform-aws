module "home" {
  source = "./modules/dns/childzonerecord"

  zone_id = data.aws_route53_zone.gawn_uk.zone_id
  name = "home.${data.aws_route53_zone.gawn_uk.name}"
}

resource "aws_ses_domain_identity" "gawn_ses_identity" {
  domain = "home.gawn.uk"
  provider = aws.eu-west-1
}

resource "aws_ses_domain_dkim" "gawn_ses_dkim" {
  domain = "home.gawn.uk"
  provider = aws.eu-west-1
}

resource "aws_route53_record" "home_verification_record" {
  name = "_amazonses.home.gawn.uk"
  type = "TXT"
  zone_id = module.home.zone_id
  ttl = "600"
  records = [
    aws_ses_domain_identity.gawn_ses_identity.verification_token]
}

resource "aws_route53_record" "home_dkim_record" {
  name = "${element(aws_ses_domain_dkim.gawn_ses_dkim.dkim_tokens, count.index)}._domainkey.home.gawn.uk"
  type = "CNAME"
  zone_id = module.home.zone_id
  count = 3
  ttl = "600"
  records = ["${element(aws_ses_domain_dkim.gawn_ses_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "gawn-uk-home-wildcard" {
  zone_id = module.home.zone_id
  name = "*.${module.home.name}"
  type = "CNAME"
  ttl = "600"
  records = ["home.gawn.uk"]
}

resource "aws_route53_record" "gawn-uk-home-cca" {
  zone_id = module.home.zone_id
  name = module.home.name
  type = "CAA"
  ttl = "600"
  records = ["0 issue \"letsencrypt.org\"", "0 issue \"amazon.com\""]
}
