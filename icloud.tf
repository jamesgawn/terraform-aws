// gawn.dev
data "aws_route53_zone" "gawn-dev" {
  name = "gawn.dev"
}

resource "aws_route53_record" "gawn-dev-email-mx" {
  zone_id = data.aws_route53_zone.gawn-dev.zone_id
  name = data.aws_route53_zone.gawn-dev.name
  type = "MX"
  ttl = "600"
  records = ["1 mx01.mail.icloud.com", "2 mx02.mail.icloud.com"]
}

resource "aws_route53_record" "gawn-dev-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.gawn-dev.zone_id
  name = data.aws_route53_zone.gawn-dev.name
  type = "TXT"
  ttl = "600"
  records = ["apple-domain=3I8i0knKEK8rBnAk", "v=spf1 redirect=icloud.com"]
}

resource "aws_route53_record" "gawn-dev-email-dkim" {
  zone_id = data.aws_route53_zone.gawn-dev.zone_id
  name = "sig1._domainkey.${data.aws_route53_zone.gawn-dev.name}"
  type = "CNAME"
  ttl = "600"
  records = ["sig1.dkim.gawn.dev.at.icloudmailadmin.com."]
}

// scary-biscuits.com
data "aws_route53_zone" "sb-com" {
  name = "scary-biscuits.com"
}
resource "aws_route53_record" "sb-com-email-mx" {
  zone_id = data.aws_route53_zone.sb-com.zone_id
  name = data.aws_route53_zone.sb-com.name
  type = "MX"
  ttl = "600"
  records = ["1 mx01.mail.icloud.com", "2 mx02.mail.icloud.com"]
}
resource "aws_route53_record" "sb-com-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.sb-com.zone_id
  name = data.aws_route53_zone.sb-com.name
  type = "TXT"
  ttl = "600"
  records = ["apple-domain=nYflSkCaAlnBZYlu", "v=spf1 redirect=icloud.com"]
}
resource "aws_route53_record" "sb-com-email-dkim" {
  zone_id = data.aws_route53_zone.sb-com.zone_id
  name = "sig1._domainkey.${data.aws_route53_zone.sb-com.name}"
  type = "CNAME"
  ttl = "600"
  records = ["sig1.dkim.scary-biscuits.com.at.icloudmailadmin.com."]
}

// scary-biscuits.co.uk
data "aws_route53_zone" "sb-co-uk" {
  name = "scary-biscuits.co.uk"
}
resource "aws_route53_record" "sb-co-uk-email-mx" {
  zone_id = data.aws_route53_zone.sb-co-uk.zone_id
  name = data.aws_route53_zone.sb-co-uk.name
  type = "MX"
  ttl = "600"
  records = ["1 mx01.mail.icloud.com", "2 mx02.mail.icloud.com"]
}
resource "aws_route53_record" "sb-co-uk-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.sb-co-uk.zone_id
  name = data.aws_route53_zone.sb-co-uk.name
  type = "TXT"
  ttl = "600"
  records = ["apple-domain=7FOSz4jNlvthmyLI", "v=spf1 redirect=icloud.com"]
}
resource "aws_route53_record" "sb-co-uk-email-dkim" {
  zone_id = data.aws_route53_zone.sb-co-uk.zone_id
  name = "sig1._domainkey.${data.aws_route53_zone.sb-co-uk.name}"
  type = "CNAME"
  ttl = "600"
  records = ["sig1.dkim.scary-biscuits.co.uk.at.icloudmailadmin.com."]
}

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