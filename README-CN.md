terraform-alicloud-market-app-with-ecs-image
=====================================================================

本 Terraform Module 将基于阿里云市场提供的 ECS 镜像来实现对应用程序，基础环境等不同自定义服务的一键搭建。为了更好的提供服务，本 Module 提供了如下几个核心功能：

1. 通过指定 ECS 实例的数量来支持创建一个基于 ECS 的服务集群；

2. 支持创建负载均衡 SLB，并将创建好的 ECS 服务集群与 SLB 进行绑定，实现请求的按需转发；

3. 支持添加 DNS 域名，并将 DNS 域名与 SLB 进行绑定，通过域名来为自定义的服务提供访问路径。

## Terraform 版本

本模板要求使用版本 Terraform 0.12 和 阿里云 Provider 1.71.0+。

## 用法

使用云市场镜像搭建 web 应用程序（以 Wordpress 为例）。

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
使用云市场镜像搭建 web 应用程序（以 Wordpress 为例），并绑定一个负载均衡实例。

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

使用云市场镜像搭建 web 应用程序（以 Wordpress 为例），并绑定一个负载均衡实例和分配一个 DNS。

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

## 示例

* [完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-with-ecs-image/tree/master/examples/complete)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com).

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
