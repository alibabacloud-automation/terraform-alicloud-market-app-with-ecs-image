############################################
# Data source to get specified product image
############################################
data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = var.product_keyword
  supplier_name_keyword = var.product_supplier_name_keyword
  suggested_price       = var.product_suggested_price
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

############################################
# Create ecs cluster
############################################
resource "alicloud_instance" "this" {
  count           = var.create_instance ? var.number_of_instance : 0
  image_id        = var.image_id != "" ? var.image_id : data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  instance_type   = var.ecs_instance_type
  security_groups = var.security_group_ids

  instance_name = format("%s%03d", var.ecs_instance_name, count.index + 1)
  password      = var.ecs_instance_password

  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size

  vswitch_id = var.vswitch_id
  private_ip = var.private_ip

  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = local.allocate_public_ip == true ? var.internet_max_bandwidth_out : 0
  description                = "An ECS instance used to deploy ${var.product_keyword}}."

  resource_group_id   = var.resource_group_id
  deletion_protection = var.deletion_protection
  force_delete        = var.force_delete
  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      name                 = lookup(data_disks.value, "name", )
      size                 = lookup(data_disks.value, "size", 20)
      category             = lookup(data_disks.value, "category", "cloud_efficiency")
      encrypted            = lookup(data_disks.value, "encrypted", null)
      snapshot_id          = lookup(data_disks.value, "snapshot_id", null)
      delete_with_instance = lookup(data_disks.value, "delete_with_instance", null)
      description          = lookup(data_disks.value, "description", null)
    }
  }
  tags = merge(
    {
      Created     = "Terraform"
      Application = "Market-${var.product_keyword}"
    }, var.tags,
  )
}

############################################
# Create SLB
############################################
locals {
  create_slb = var.create_instance ? var.create_slb : false
  servers_of_virtual_server_group = [
    {
      server_ids = join(",", alicloud_instance.this.*.id)
      port       = var.instance_port
      weight     = var.instance_weight_in_server_group
      type       = "ecs"
    },
  ]
}

module "slb" {
  source = "alibaba/slb/alicloud"

  create                          = local.create_slb
  use_existing_slb                = var.use_existing_slb
  existing_slb_id                 = var.existing_slb_id
  name                            = var.slb_name
  internet_charge_type            = var.slb_internet_charge_type
  address_type                    = var.address_type
  vswitch_id                      = var.vswitch_id
  spec                            = var.slb_spec
  bandwidth                       = var.bandwidth
  master_zone_id                  = var.master_zone_id
  slave_zone_id                   = var.slave_zone_id
  virtual_server_group_name       = var.virtual_server_group_name
  servers_of_virtual_server_group = local.servers_of_virtual_server_group
  tags                            = var.slb_tags

}

resource "alicloud_slb_listener" "this" {
  count            = local.create_slb || var.use_existing_slb ? 1 : 0
  frontend_port    = var.frontend_port
  load_balancer_id = module.slb.this_slb_id
  protocol         = "http"
  bandwidth        = var.bandwidth
  server_group_id  = module.slb.this_slb_virtual_server_group_id
}

############################################
# Create DNS
############################################
data "alicloud_slbs" "this" {
  ids = var.existing_slb_id != "" ? [var.existing_slb_id] : null
}

locals {
  allocate_public_ip = !var.create_instance ? false : local.create_slb ? false : var.allocate_public_ip
  create_dns         = var.bind_domain
  value              = var.create_slb ? module.slb.this_slb_address : var.existing_slb_id != "" ? data.alicloud_slbs.this.slbs.0.address : null
  records = [
    {
      value    = local.value
      rr       = lookup(var.dns_record, "host_record", "")
      type     = lookup(var.dns_record, "type", "")
      ttl      = lookup(var.dns_record, "ttl", 600)
      priority = lookup(var.dns_record, "priority", 1)
      line     = lookup(var.dns_record, "line", "default")
    }
  ]
  this_app_url = var.bind_domain ? format("%s%s", lookup(var.dns_record, "host_record", "") != "" ? "${lookup(var.dns_record, "host_record", "")}." : "", var.domain_name) : local.create_slb ? format("%s:${var.frontend_port}", concat([module.slb.this_slb_address], [""])[0]) : var.create_instance ? format("%s:${var.instance_port}", concat(alicloud_instance.this.*.public_ip, [""])[0]) : ""

}

module "dns" {
  source = "terraform-alicloud-modules/dns/alicloud"

  create      = local.create_dns
  domain_name = var.domain_name
  records     = local.records

}