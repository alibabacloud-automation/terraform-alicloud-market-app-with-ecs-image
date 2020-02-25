Terraform Module for creating web application based on Alibaba Cloud market place ECS image.  
terraform-alicloud-market-app-with-ecs-image
=============================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-with-ecs-image/blob/master/README-CN.md)

Terraform Module will be based on the ECS mirror provided by the Alicloud market to implement the application, basic environment and other different custom services one-click building. For better service delivery, this Module offers the following core functions:

1. Support the creation of an ECS service cluster by specifying the number of ECS instances;

2. Supports the creation of SLB and binds the created ECS service cluster to SLB to enable on-demand forwarding of requests;

3. Support to add DNS domain name and bind DNS domain name to SLB to provide access path for custom service through domain name.

## Terraform versions

The Module requires Terraform 0.12 and Terraform Provider AliCloud 1.71.0+.

## Usage

Building the web application (e.g.,Wordpress) using market place image.

```hcl
module "market_application_with_ecs" {
  source                     = "terraform-alicloud-modules/market-app-with-ecs-image/alicloud"
  region                     = "cn-beijing"
  profile                    = "Your-Profile-Name"

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
  region                = "cn-beijing"
  profile               = "Your-Profile-Name"

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
  region                = "cn-beijing"
  profile               = "Your-Profile-Name"

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
* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com).

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
