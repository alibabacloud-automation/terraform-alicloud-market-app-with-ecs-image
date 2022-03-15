terraform-alicloud-market-app-with-ecs-image
=====================================================================

本 Terraform Module 将基于阿里云市场提供的 ECS 镜像来实现对应用程序，基础环境等不同自定义服务的一键搭建。为了更好的提供服务，本 Module 提供了如下几个核心功能：

1. 通过指定 ECS 实例的数量来支持创建一个基于 ECS 的服务集群；

2. 支持创建负载均衡 SLB，并将创建好的 ECS 服务集群与 SLB 进行绑定，实现请求的按需转发；

3. 支持添加 DNS 域名，并将 DNS 域名与 SLB 进行绑定，通过域名来为自定义的服务提供访问路径。

## 用法

使用云市场镜像搭建 web 应用程序（以 Wordpress 为例）。

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
使用云市场镜像搭建 web 应用程序（以 Wordpress 为例），并绑定一个负载均衡实例。

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

使用云市场镜像搭建 web 应用程序（以 Wordpress 为例），并绑定一个负载均衡实例和分配一个 DNS。

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

## 示例

* [完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-with-ecs-image/tree/master/examples/complete)

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显式设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/market-app-with-ecs-image"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

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

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.0 |

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)