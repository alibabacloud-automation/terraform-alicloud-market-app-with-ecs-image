Terraform Module for creating web application based on Alibaba Cloud market place ECS image.  
terraform-alicloud-market-app-with-ecs-image
=============================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-with-ecs-image/blob/master/README-CN.md)

Terraform Module will be based on the ECS mirror provided by the Alicloud market to implement the application, basic environment and other different custom services one-click building. For better service delivery, this Module offers the following core functions:

1. Support the creation of an ECS service cluster by specifying the number of ECS instances;

2. Supports the creation of SLB and binds the created ECS service cluster to SLB to enable on-demand forwarding of requests;

3. Support to add DNS domain name and bind DNS domain name to SLB to provide access path for custom service through domain name.

## Usage

Building the web application (e.g.,Wordpress) using market place image.

```hcl
module "market_application_with_ecs" {
  source                     = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"

  product_keyword            = "Wordpress"

  number_of_instance         = 2
  ecs_instance_name          = "Wordpress-instance"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = data.alicloud_instance_types.this.ids.0
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 50
  instance_port              = 80
  allocate_public_ip         = true
  data_disks = [
    {
      name = "disk-for-Wordpress"
      size = 50
    }
  ]
}
```

Building the web application (e.g.,Wordpress) using market place image and bind a slb.

```hcl
module "market_application_with_slb" {
  source                = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"

  product_keyword       = "Wordpress"

  number_of_instance    = 2
  ecs_instance_name     = "Wordpress-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = data.alicloud_instance_types.this.ids.0
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = [module.security_group.this_security_group_id]
  vswitch_id            = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  instance_port         = 80
  frontend_port         = 8080

  create_slb                      = true
  slb_name                        = "for-Wordpress"
  bandwidth                       = 5
  slb_spec                        = "slb.s1.small"
  instance_weight_in_server_group = "100"
}
```

Building the web application (e.g.,Wordpress) using market place image and bind a slb to dns.

```hcl
module "market_application_with_dns" {
  source                = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"

  product_keyword       = "Wordpress"

  number_of_instance    = 2
  ecs_instance_name     = "Wordpress-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = data.alicloud_instance_types.this.ids.0
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = [module.security_group.this_security_group_id]
  vswitch_id            = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  instance_port         = 80

  create_slb                      = true
  slb_name                        = "for-Wordpress"
  frontend_port                   = 8080
  bandwidth                       = 5
  slb_spec                        = "slb.s1.small"
  instance_weight_in_server_group = "100"

  bind_domain = true
  domain_name = "dns001.abc"
  dns_record = {
    host_record = "wordpress"
    type        = "A"
  }
}
```
## Examples

* [complete](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-with-ecs-image/tree/master/examples/complete)

## Notes
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/market-app-with-ecs-image"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "market_application_with_ecs" {
  source             = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"
  version            = "1.0.0"
  region             = "cn-beijing"
  profile            = "Your-Profile-Name"
  product_keyword    = "Wordpress"
  number_of_instance = 2
  // ...
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
}
module "market_application_with_ecs" {
  source             = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"
  product_keyword    = "Wordpress"
  number_of_instance = 2
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
  alias   = "bj"
}
module "market_wordpress_with_ecs" {
  source             = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"
  providers          = {
    alicloud = alicloud.bj
  }
  product_keyword    = "Wordpress"
  number_of_instance = 2
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.0 |

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
