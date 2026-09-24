resource "aws_ec2_transit_gateway_vpc_attachment" "resource" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  appliance_mode_support = var.appliance_mode_support ? "enable" : "disable"
  dns_support            = var.dns_support ? "enable" : "disable"
  ipv6_support           = var.ipv6_support ? "enable" : "disable"
  security_group_referencing_support = var.security_group_referencing_support == null ? null : (
    var.security_group_referencing_support ? "enable" : "disable"
  )

  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = merge(var.tags, { name = "attachment" })
}

output "id" {
  description = "The ID of the transit gateway VPC attachment."
  value       = aws_ec2_transit_gateway_vpc_attachment.resource.id
}

output "arn" {
  description = "The ARN of the transit gateway VPC attachment."
  value       = aws_ec2_transit_gateway_vpc_attachment.resource.arn
}

output "vpc_owner_id" {
  description = "AWS account ID that owns the attached VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment.resource.vpc_owner_id
}
