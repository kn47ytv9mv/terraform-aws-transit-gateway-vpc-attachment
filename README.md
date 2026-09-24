# terraform-aws-transit-gateway-vpc-attachment

Terraform module for attaching one VPC to a transit gateway.

## Cost

Bills hourly for as long as it exists, plus a per-gigabyte data
processing charge for traffic crossing it — the transit gateway's own
per-attachment cost originates here. See AWS's
[Transit Gateway pricing](https://aws.amazon.com/transit-gateway/pricing/)
page for current rates.

## Usage

```hcl
module "attachment" {
  source = "kn47ytv9mv/transit-gateway-vpc-attachment/aws"

  transit_gateway_id = module.transit_gateway.id
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids["private"]
}
```

Or directly from this repository:

```hcl
module "attachment" {
  source = "github.com/kn47ytv9mv/terraform-aws-transit-gateway-vpc-attachment"

  transit_gateway_id                 = module.transit_gateway.id
  vpc_id                             = module.vpc.vpc_id
  subnet_ids                         = module.vpc.subnet_ids["private"]
  security_group_referencing_support = true
}
```

Once attached, give the VPC's tiers a route toward the transit gateway
using `terraform-aws-vpc`'s `custom_routes`, referencing this module's
`transit_gateway_id`:

```hcl
subnets = {
  private = {
    nat_gateway_access = true
    custom_routes = [{
      cidr_block         = "10.0.0.0/8"
      transit_gateway_id = module.transit_gateway.id
    }]
  }
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.0 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| transit_gateway_id | The ID of the transit gateway to attach this VPC to. | `null` | no |
| vpc_id | The ID of the VPC to attach. | `null` | no |
| subnet_ids | Subnet IDs to place the attachment's ENIs in, one per availability zone — AWS allows only one subnet per AZ per attachment, the same constraint interface VPC endpoints have. | `null` | no |
| appliance_mode_support | Whether appliance mode is enabled, so traffic between two subnets always transits the same availability zone's ENI — required for stateful network appliances that need symmetric routing. | `false` | no |
| dns_support | Whether DNS support is enabled for this attachment. | `true` | no |
| ipv6_support | Whether IPv6 support is enabled for this attachment. | `false` | no |
| security_group_referencing_support | Whether this VPC's security groups can reference other attached VPCs' security group IDs across the transit gateway. Must also be enabled on the transit gateway itself (see `terraform-aws-transit-gateway`) to take effect. If null, AWS's own default applies. | `null` | no |
| transit_gateway_default_route_table_association | Whether this attachment is automatically associated with the transit gateway's default association route table. | `true` | no |
| transit_gateway_default_route_table_propagation | Whether this attachment automatically propagates routes into the transit gateway's default propagation route table. | `true` | no |
| tags | A map of tags to assign to the attachment. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the transit gateway VPC attachment. |
| arn | The ARN of the transit gateway VPC attachment. |
| vpc_owner_id | AWS account ID that owns the attached VPC. |

## License

MIT — see [LICENSE.md](LICENSE.md).
