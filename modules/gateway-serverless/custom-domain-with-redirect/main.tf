variable "zone" {
  type = string
  description = "The name of the zone which contains the domain"
}

variable "domains" {
  type = list(string)
  description = "The list of domains to map to the gateway"
}

variable "gateway_id" {
  type = string
  description = "The ID for the gateway to attach to"
}

/*
 * Data Sources 
 */

data "aws_route53_zone" "zone" {
  name         = var.zone
  private_zone = false
}

data "aws_apigatewayv2_api" "gateway" {
  api_id = var.gateway_id
}


/*
 * Certificate Generation
 */
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domains[0]
  validation_method = "DNS"

  subject_alternative_names = var.domains

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

/*
 * Cloudfront distribution
 */

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    origin_id = "gateway"
    domain_name = data.aws_apigatewayv2_api.gateway.api_endpoint
  }

  enabled             = true
  is_ipv6_enabled     = true

  aliases = var.domains

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.domains[0]

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    compress = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
  }
}

/*
 * Map domains to cloudfront distribution
 */

resource "aws_route53_record" "api-ipv4" {
  for_each = toset(var.domains)

  name    = each.key
  type    = "A"
  zone_id = data.aws_route53_zone.api.zone_id

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
  allow_overwrite = true
}

resource "aws_route53_record" "api-ipv6" {
  for_each = toset(var.domains)

  name    = each.key
  type    = "AAAA"
  zone_id = data.aws_route53_zone.api.zone_id

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
  allow_overwrite = true
}