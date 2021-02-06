resource "aws_route53_zone" "dev-zone" {
  name = "gawn.dev"
}

output "name" {
  value = aws_route53_zone.dev-zone.name
}

resource "aws_route53_record" "gawn-dev-wildcard" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = "*.gawn.uk"
  type = "CNAME"
  ttl = "600"
  records = ["cluster.gawn.dev"]
}

resource "aws_route53_record" "gawn-dev-home-cca" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = aws_route53_zone.dev-zone.name
  type = "CAA"
  ttl = "600"
  records = ["0 issue \"letsencrypt.org\"", "0 issue \"amazon.com\""]
}

resource "aws_ses_domain_identity" "gawn_dev" {
  domain = "gawn.dev"
}

resource "aws_ses_domain_dkim" "gawn_dev" {
  domain = "gawn.dev"
}

resource "aws_route53_record" "gawn_dev_verification_record" {
  name = "_amazonses.gawn.dev"
  type = "TXT"
  zone_id = aws_route53_zone.dev-zone.zone_id
  ttl = "600"
  records = [
    aws_ses_domain_identity.gawn_dev.verification_token]
}

resource "aws_route53_record" "gawn_dev_dkim_record" {
  name = "${element(aws_ses_domain_dkim.gawn_dev.dkim_tokens, count.index)}._domainkey.home.gawn.uk"
  type = "CNAME"
  zone_id = aws_route53_zone.dev-zone.zone_id
  count = 3
  ttl = "600"
  records = ["${element(aws_ses_domain_dkim.gawn_dev.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
