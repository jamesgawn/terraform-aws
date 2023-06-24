// gawn.uk
data "aws_route53_zone" "gawn-uk" {
  name = "gawn.uk"
}
resource "aws_route53_record" "gawn-uk-email-mx" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = data.aws_route53_zone.gawn-uk.name
  type = "MX"
  ttl = "300"
  records = ["1 mx01.mail.icloud.com", "2 mx02.mail.icloud.com"]
}
resource "aws_route53_record" "gawn-uk-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = data.aws_route53_zone.gawn-uk.name
  type = "TXT"
  ttl = "300"
  records = ["apple-domain=w2qHBNd0CWllLubd", "v=spf1 redirect=icloud.com"]
}
resource "aws_route53_record" "gawn-uk-email-dkim" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = "sig1._domainkey.${data.aws_route53_zone.gawn-uk.name}"
  type = "CNAME"
  ttl = "300"
  records = ["sig1.dkim.gawn.uk.at.icloudmailadmin.com."]
  }