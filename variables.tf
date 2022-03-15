variable "region" {
  description = "(Deprecated from version 1.1.0) The region used to launch this module resources."
  type        = string
  default     = ""
}
variable "profile" {
  description = "(Deprecated from version 1.1.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}
variable "shared_credentials_file" {
  description = "(Deprecated from version 1.1.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}
variable "skip_region_validation" {
  description = "(Deprecated from version 1.1.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

###################
# Market Product
###################
variable "product_keyword" {
  description = "The name keyword of Market Product used to fetch the specified product image."
  type        = string
  default     = ""
}
variable "product_supplier_name_keyword" {
  description = "The name keyword of Market Product supplier name used to fetch the specified product image."
  type        = string
  default     = ""
}
variable "product_suggested_price" {
  description = "The suggested price of Market Product used to fetch the specified product image."
  type        = number
  default     = 0
}

###################
# ECS instance
###################
variable "create_instance" {
  description = "Whether to create ecs instance."
  type        = bool
  default     = true
}

variable "number_of_instance" {
  description = "The number of ecs to be created."
  type        = number
  default     = 1
}

variable "image_id" {
  description = "The image id used to launch one ecs instance. If not set, a fetched market place image by product_keyword will be used."
  type        = string
  default     = ""
}

variable "ecs_instance_type" {
  description = "The instance type used to launch ecs instance."
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "A list of security group ids to associate with ECS Instance."
  type        = list(string)
  default     = []
}

variable "ecs_instance_name" {
  description = "The name of ECS Instance."
  type        = string
  default     = ""
}

variable "ecs_instance_password" {
  description = "The password of ECS instance."
  type        = string
  default     = ""
}

variable "system_disk_category" {
  description = "The system disk category used to launch one ecs instance."
  type        = string
  default     = "cloud_ssd"
}

variable "system_disk_size" {
  description = "The system disk size used to launch ecs instance."
  type        = number
  default     = 40
}

variable "vswitch_id" {
  description = "The virtual switch ID to launch ECS instance in VPC."
  type        = string
  default     = ""
}

variable "private_ip" {
  description = "Configure ECS Instance private IP address"
  type        = string
  default     = ""
}

variable "internet_charge_type" {
  description = "The internet charge type of ECS instance. Choices are 'PayByTraffic' and 'PayByBandwidth'."
  type        = string
  default     = "PayByTraffic"
}

variable "allocate_public_ip" {
  description = "Whether to allocate public ip for ECS instance. If 'create_slb' is true, it will be ignore."
  type        = bool
  default     = false
}

variable "internet_max_bandwidth_out" {
  description = "The maximum internet out bandwidth of ECS instance."
  type        = number
  default     = 10
}

variable "resource_group_id" {
  description = "The Id of resource group which the ECS instance belongs."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Whether enable the deletion protection or not. 'true': Enable deletion protection. 'false': Disable deletion protection."
  type        = bool
  default     = false
}

variable "force_delete" {
  description = "If it is true, the 'PrePaid' instance will be change to 'PostPaid' and then deleted forcibly. However, because of changing instance charge type has CPU core count quota limitation, so strongly recommand that 'Don't modify instance charge type frequentlly in one month'."
  type        = bool
  default     = true
}

variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance."
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the ECS and SLB."
  type        = map(string)
  default     = {}
}

###################
# slb
###################
variable "create_slb" {
  description = "Whether to create a balancer instance."
  type        = bool
  default     = false
}

variable "use_existing_slb" {
  description = "Whether to use an existing load balancer instance. If true, 'existing_slb_id' should not be empty. Also, you can create a new one by setting 'create = true'."
  type        = bool
  default     = false
}

variable "existing_slb_id" {
  description = "An existing load balancer instance id."
  type        = string
  default     = ""
}

variable "slb_name" {
  description = "The name of a new load balancer."
  type        = string
  default     = ""
}

variable "slb_internet_charge_type" {
  description = "The charge type of load balancer instance internet network."
  type        = string
  default     = "PayByTraffic"
}

variable "address_type" {
  description = "The type if address. Choices are 'intranet' and 'internet'. Default to 'internet'."
  type        = string
  default     = "internet"
}

variable "slb_spec" {
  description = "The specification of the SLB instance."
  type        = string
  default     = "slb.s1.small"
}

variable "bandwidth" {
  description = "The load balancer instance bandwidth."
  type        = number
  default     = 10
}

variable "master_zone_id" {
  description = "The primary zone ID of the SLB instance. If not specified, the system will be randomly assigned."
  type        = string
  default     = ""
}

variable "slave_zone_id" {
  description = "The standby zone ID of the SLB instance. If not specified, the system will be randomly assigned."
  type        = string
  default     = ""
}

variable "virtual_server_group_name" {
  description = "The name virtual server group. If not set, the 'name' and adding suffix '-virtual' will return."
  type        = string
  default     = ""
}

variable "instance_port" {
  description = "The port of instance."
  type        = number
  default     = 8080
}

variable "instance_weight_in_server_group" {
  description = "The weight of instance in server group."
  type        = number
  default     = 10
}

variable "slb_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "frontend_port" {
  description = "The fronted port of balancer."
  type        = number
  default     = 80
}

###################
# dns
###################
variable "bind_domain" {
  description = "Whether to bind domain."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The name of domain."
  type        = string
  default     = ""
}

variable "dns_record" {
  description = "DNS record. Each item can contains keys: 'host_record'(The host record of the domain record.),'type'(The type of the domain. Valid values: A, NS, MX, TXT, CNAME, SRV, AAAA, CAA, REDIRECT_URL, FORWORD_URL. Default to A.),'priority'(The priority of domain record. Valid values are `[1-10]`. When the `type` is `MX`, this parameter is required.),'ttl'(The ttl of the domain record. Default to 600.),'line'(The resolution line of domain record. Default value is default.)."
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time."
  type        = map(string)
  default     = {}
}