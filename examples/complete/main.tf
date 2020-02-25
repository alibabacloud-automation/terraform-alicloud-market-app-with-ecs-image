variable "profile" {
  default = "default"
}

variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}

#############################################################
# Data sources to get VPC, vswitch details
#############################################################
data "alicloud_vpcs" "default" {
  is_default = true
}

data "alicloud_vswitches" "default" {
  ids = [data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0]
}

data "alicloud_instance_types" "this" {
  cpu_core_count    = 1
  memory_size       = 2
  availability_zone = data.alicloud_vswitches.default.vswitches.0.zone_id
}

#############################################################
# Create a new security and open all ports
#############################################################
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  profile             = var.profile
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "web-applacation"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

#############################################################
# Building the web application using market place image
#############################################################
module "market_application_with_ecs" {
  source  = "../.."
  region  = var.region
  profile = var.profile

  product_keyword = "Wordpress"

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

#############################################################
# Create a new slb to attach ecs instances
#############################################################
module "market_application_with_slb" {
  source  = "../.."
  region  = var.region
  profile = var.profile

  product_keyword = "Wordpress"

  number_of_instance    = 2
  ecs_instance_name     = "Wordpress-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = data.alicloud_instance_types.this.ids.0
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = [module.security_group.this_security_group_id]
  vswitch_id            = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  instance_port         = 80
  frontend_port         = 8081

  create_slb                      = true
  slb_name                        = "for-Wordpress"
  bandwidth                       = 5
  slb_spec                        = "slb.s1.small"
  instance_weight_in_server_group = "100"
}

#############################################################
# Bind a dns domain for this module
#############################################################
module "market_application_with_dns" {
  source  = "../.."
  region  = var.region
  profile = var.profile

  product_keyword = "Wordpress"

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
