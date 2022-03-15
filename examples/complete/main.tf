provider "alicloud" {
  region = "cn-shenzhen"
}

data "alicloud_zones" "default" {
}

data "alicloud_resource_manager_resource_groups" "default" {
}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = "Wordpress"
  supplier_name_keyword = "软件"
  suggested_price       = 0
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

data "alicloud_instance_types" "this" {
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_ecs_disk" "default" {
  zone_id = data.alicloud_zones.default.zones.0.id
  size    = var.system_disk_size
}

resource "alicloud_ecs_snapshot" "default" {
  disk_id  = alicloud_ecs_disk_attachment.default.disk_id
  category = "standard"
  force    = var.force_delete
}

resource "alicloud_ecs_disk_attachment" "default" {
  disk_id     = alicloud_ecs_disk.default.id
  instance_id = module.ecs_instance.this_instance_id[0]
}

# Create a new vpc using terraform module
module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/16"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_zones.default.zones.0.id]
}

# Create a new security and open all ports
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  vpc_id              = module.vpc.this_vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

module "ecs_instance" {
  source = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.this.instance_types.0.id
  image_id           = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  vswitch_ids        = [module.vpc.this_vswitch_ids[0]]
  security_group_ids = [module.security_group.this_security_group_id]
}

# Create a new slb to attach ecs instances
module "market_application_with_ecs_slb" {
  source = "../.."

  #alicloud_market_products
  product_keyword               = "Wordpress"
  product_supplier_name_keyword = "软件"
  product_suggested_price       = 0

  #alicloud_instance
  create_instance = true

  number_of_instance         = 1
  image_id                   = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  ecs_instance_type          = data.alicloud_instance_types.this.ids.0
  security_group_ids         = [module.security_group.this_security_group_id]
  ecs_instance_name          = var.ecs_instance_name
  ecs_instance_password      = var.ecs_instance_password
  system_disk_category       = "cloud_efficiency"
  system_disk_size           = var.system_disk_size
  vswitch_id                 = module.vpc.this_vswitch_ids[0]
  private_ip                 = var.private_ip
  internet_charge_type       = var.internet_charge_type
  allocate_public_ip         = true
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  resource_group_id          = data.alicloud_resource_manager_resource_groups.default.groups.0.id
  deletion_protection        = var.deletion_protection
  force_delete               = var.force_delete
  data_disks = [{
    name                 = "data_disks_name"
    size                 = 20
    category             = "cloud_efficiency"
    encrypted            = false
    snapshot_id          = alicloud_ecs_snapshot.default.id
    delete_with_instance = true
    description          = "tf-wordpress-description"
  }]
  tags = var.tags

  # Create SLB
  create_slb       = true
  use_existing_slb = false

  slb_name                        = var.slb_name
  slb_internet_charge_type        = "PayByTraffic"
  address_type                    = "intranet"
  slb_spec                        = var.slb_spec
  bandwidth                       = var.bandwidth
  master_zone_id                  = data.alicloud_zones.default.zones.0.id
  slave_zone_id                   = data.alicloud_zones.default.zones.1.id
  virtual_server_group_name       = var.virtual_server_group_name
  instance_port                   = var.instance_port
  instance_weight_in_server_group = var.instance_weight_in_server_group
  slb_tags                        = var.slb_tags

  #alicloud_slb_listener
  frontend_port = "80"

  # Create DNS
  bind_domain = false

}

# Bind a dns domain for this module
module "market_application_with_dns" {
  source = "../.."

  #alicloud_instance
  create_instance = false

  # Create SLB
  create_slb       = false
  use_existing_slb = false

  # Create DNS
  bind_domain = true

  domain_name     = "dns168.abc"
  existing_slb_id = module.market_application_with_ecs_slb.this_slb_id
  dns_record      = var.dns_record

}