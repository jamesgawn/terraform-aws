variable "domain" {
  type = string
  description = "The domain you wish to attach to the gateway. e.g. api.gawn.uk"
}

variable "zone" {
  type = string
  description = "The name of the zone which contains the domain"
}

variable "gateway_id" {
  type = string
  description = "The ID for the gateway to attach to"
}

variable "gateway_stage_id" {
  type = string
  description = "The ID for the gateway stage to attach to"
}

data "aws_route53_zone" "zone" {
  name         = var.zone
  private_zone = false
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = var.domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = var.gateway_id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = var.gateway_stage_id
}

data "aws_route53_zone" "api" {
  name = var.zone
  private_zone = false
}

resource "aws_route53_record" "api" {
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.api.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}