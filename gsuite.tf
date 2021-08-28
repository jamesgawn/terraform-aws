// gawn.uk
data "aws_route53_zone" "gawn-uk" {
  name = "gawn.uk"
}
resource "aws_route53_record" "gawn-uk-email-mx" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = data.aws_route53_zone.gawn-uk.name
  type = "MX"
  ttl = "300"
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
resource "aws_route53_record" "gawn-uk-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = data.aws_route53_zone.gawn-uk.name
  type = "TXT"
  ttl = "300"
  records = ["v=spf1 include:_spf.google.com ~all"]
}
resource "aws_route53_record" "gawn-uk-email-dkim" {
  zone_id = data.aws_route53_zone.gawn-uk.zone_id
  name = "mailauth._domainkey.${data.aws_route53_zone.gawn-uk.name}"
  type = "TXT"
  ttl = "300"
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCSKIualHjOyfzkR6VWrMTx3vPzZhwzUcu0VMZFRYxPNh8X2l0dWeZJdCn5W+wLaVFK6PnYerrDW6b0lGzVPE/QDlgAGCG8MkqyLf85PTqHxXtEba4ykdqJZAL9fueiTI1Imf0KMiY13yro+IaVB8E6LL51wUQfOlpBbbA/K/Pb8wIDAQAB"]
}

// gawn.co.uk
data "aws_route53_zone" "gawn-co-uk" {
  name = "gawn.co.uk"
}
resource "aws_route53_record" "gawn-co-uk-email-mx" {
  zone_id = data.aws_route53_zone.gawn-co-uk.zone_id
  name = data.aws_route53_zone.gawn-co-uk.name
  type = "MX"
  ttl = "300"
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
resource "aws_route53_record" "gawn-co-uk-email-txt-domainkey" {
  zone_id = data.aws_route53_zone.gawn-co-uk.zone_id
  name = data.aws_route53_zone.gawn-co-uk.name
  type = "TXT"
  ttl = "300"
  records = ["v=spf1 include:_spf.google.com ~all"]
}
resource "aws_route53_record" "gawn-co-uk-email-dkim" {
  zone_id = data.aws_route53_zone.gawn-co-uk.zone_id
  name = "gawn._domainkey.${data.aws_route53_zone.gawn-co-uk.name}"
  type = "TXT"
  ttl = "300"
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCSx1x+RX9Y6Gt6kZgumhbVl+l0x+dX883XW7yzuFi/nQEKQ4HTcCvq1T+jfyatrzPD4XmsaP+JhccAdS2I7m8RkOCE/Yk0AQpxyB7NTL/0macCVBdOzWgMbGFXfCicj0sVZRNdvpQGVmAgtPVLmNzh5Lfx8ASOmXj6WLlo3048IwIDAQAB"]
}