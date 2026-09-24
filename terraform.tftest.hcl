mock_provider "aws" {
}

run "defaults_match_aws_own_defaults" {
  command = apply

  variables {
    transit_gateway_id = "tgw-0123456789abcdef0"
    vpc_id             = "vpc-0123456789abcdef0"
    subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.appliance_mode_support == "disable"
    error_message = "appliance_mode_support should default to 'disable', matching AWS's own default."
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.dns_support == "enable"
    error_message = "dns_support should default to 'enable', matching AWS's own default."
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.ipv6_support == "disable"
    error_message = "ipv6_support should default to 'disable', matching AWS's own default."
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.transit_gateway_default_route_table_association == true
    error_message = "transit_gateway_default_route_table_association should default to true, matching AWS's own default."
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.transit_gateway_default_route_table_propagation == true
    error_message = "transit_gateway_default_route_table_propagation should default to true, matching AWS's own default."
  }
}

run "every_bool_flips_the_aws_string_value" {
  command = plan

  variables {
    transit_gateway_id                              = "tgw-0123456789abcdef0"
    vpc_id                                          = "vpc-0123456789abcdef0"
    subnet_ids                                      = ["subnet-0123456789abcdef0"]
    appliance_mode_support                          = true
    dns_support                                     = false
    ipv6_support                                    = true
    security_group_referencing_support              = true
    transit_gateway_default_route_table_association = false
    transit_gateway_default_route_table_propagation = false
  }

  assert {
    condition = (
      aws_ec2_transit_gateway_vpc_attachment.resource.appliance_mode_support == "enable" &&
      aws_ec2_transit_gateway_vpc_attachment.resource.dns_support == "disable" &&
      aws_ec2_transit_gateway_vpc_attachment.resource.ipv6_support == "enable" &&
      aws_ec2_transit_gateway_vpc_attachment.resource.security_group_referencing_support == "enable" &&
      aws_ec2_transit_gateway_vpc_attachment.resource.transit_gateway_default_route_table_association == false &&
      aws_ec2_transit_gateway_vpc_attachment.resource.transit_gateway_default_route_table_propagation == false
    )
    error_message = "Every variable should flip its corresponding attribute to the non-default value."
  }
}

run "readme_default_example" {
  command = plan

  variables {
    transit_gateway_id = "tgw-0123456789abcdef0"
    vpc_id             = "vpc-0123456789abcdef0"
    subnet_ids         = ["subnet-0123456789abcdef0"]
  }
}

run "readme_custom_example" {
  command = plan

  variables {
    transit_gateway_id                 = "tgw-0123456789abcdef0"
    vpc_id                             = "vpc-0123456789abcdef0"
    subnet_ids                         = ["subnet-0123456789abcdef0"]
    security_group_referencing_support = true
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.resource.security_group_referencing_support == "enable"
    error_message = "The README's custom example should enable security group referencing."
  }
}
