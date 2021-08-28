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