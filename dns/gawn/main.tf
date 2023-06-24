variable "domain" {
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

resource "aws_route53_record" "gawn-uk-home-cca" {
  zone_id = aws_route53_zone.gawn.zone_id
  name = aws_route53_zone.gawn.name
  type = "CAA"
  ttl = "600"
  records = ["0 issue \"letsencrypt.org\"", "0 issue \"amazon.com\""]
}
