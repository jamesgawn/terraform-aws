resource "aws_route53_zone" "dev-zone" {
  name = "gawn.dev"
}

resource "aws_route53_record" "gawn-dev-wildcard" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = "*"
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
  name = "${element(aws_ses_domain_dkim.gawn_dev.dkim_tokens, count.index)}._domainkey.${aws_route53_zone.dev-zone.name}"
  type = "CNAME"
  zone_id = aws_route53_zone.dev-zone.zone_id
  count = 3
  ttl = "600"
  records = ["${element(aws_ses_domain_dkim.gawn_dev.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

// iCloud E-mail Config
resource "aws_route53_record" "gawn-dev-email-mx" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = aws_route53_zone.dev-zone.name
  type = "MX"
  ttl = "600"
  records = ["1 mx01.mail.icloud.com", "2 mx02.mail.icloud.com"]
}

resource "aws_route53_record" "gawn-dev-email-txt-domainkey" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = aws_route53_zone.dev-zone.name
  type = "TXT"
  ttl = "600"
  records = ["apple-domain=3I8i0knKEK8rBnAk", "v=spf1 redirect=icloud.com"]
}

resource "aws_route53_record" "gawn-dev-email-dkim" {
  zone_id = aws_route53_zone.dev-zone.zone_id
  name = "sig1._domainkey.${aws_route53_zone.dev-zone.name}"
  type = "CNAME"
  ttl = "600"
  records = ["sig1.dkim.gawn.dev.at.icloudmailadmin.com."]
}