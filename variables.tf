variable "transit_gateway_id" {
  default     = null
  description = "The ID of the transit gateway to attach this VPC to."
}

variable "vpc_id" {
  default     = null
  description = "The ID of the VPC to attach."
}

variable "subnet_ids" {
  default     = null
  description = "Subnet IDs to place the attachment's ENIs in, one per availability zone — AWS allows only one subnet per AZ per attachment, the same constraint interface VPC endpoints have."
}

variable "appliance_mode_support" {
  default     = false
  description = "Whether appliance mode is enabled, so traffic between two subnets always transits the same availability zone's ENI — required for stateful network appliances that need symmetric routing."
}

variable "dns_support" {
  default     = true
  description = "Whether DNS support is enabled for this attachment."
}

variable "ipv6_support" {
  default     = false
  description = "Whether IPv6 support is enabled for this attachment."
}

variable "security_group_referencing_support" {
  default     = null
  description = "Whether this VPC's security groups can reference other attached VPCs' security group IDs across the transit gateway. Must also be enabled on the transit gateway itself (see terraform-aws-transit-gateway) to take effect. If null, AWS's own default applies."
}

variable "transit_gateway_default_route_table_association" {
  default     = true
  description = "Whether this attachment is automatically associated with the transit gateway's default association route table."
}

variable "transit_gateway_default_route_table_propagation" {
  default     = true
  description = "Whether this attachment automatically propagates routes into the transit gateway's default propagation route table."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the attachment."
}
