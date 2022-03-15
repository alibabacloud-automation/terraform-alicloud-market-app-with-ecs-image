###################
# ECS instance
###################
variable "ecs_instance_name" {
  description = "The name of ECS Instance."
  type        = string
  default     = "tf-testacc-instance"
}

variable "ecs_instance_password" {
  description = "The password of ECS instance."
  type        = string
  default     = "YourPassword123!"
}

variable "system_disk_size" {
  description = "The system disk size used to launch ecs instance."
  type        = number
  default     = 40
}

variable "private_ip" {
  description = "Configure ECS Instance private IP address"
  type        = string
  default     = "172.16.0.10"
}

variable "internet_charge_type" {
  description = "The internet charge type of ECS instance. Choices are 'PayByTraffic' and 'PayByBandwidth'."
  type        = string
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_out" {
  description = "The maximum internet out bandwidth of ECS instance."
  type        = number
  default     = 10
}

variable "deletion_protection" {
  description = "Whether enable the deletion protection or not. 'true': Enable deletion protection. 'false': Disable deletion protection."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If it is true, the 'PrePaid' instance will be change to 'PostPaid' and then deleted forcibly. However, because of changing instance charge type has CPU core count quota limitation, so strongly recommand that 'Don't modify instance charge type frequentlly in one month'."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the ECS and SLB."
  type        = map(string)
  default = {
    Name = "ECS"
  }
}

###################
# slb
###################
variable "slb_name" {
  description = "The name of a new load balancer."
  type        = string
  default     = "tf-testacc-slb-name"
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

variable "virtual_server_group_name" {
  description = "The name virtual server group. If not set, the 'name' and adding suffix '-virtual' will return."
  type        = string
  default     = "tf-testacc-server-group-name"
}

variable "instance_port" {
  description = "The port of instance."
  type        = number
  default     = 80
}

variable "instance_weight_in_server_group" {
  description = "The weight of instance in server group."
  type        = number
  default     = 10
}

variable "slb_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    Name = "SLB"
  }
}

###################
# dns
###################
variable "dns_record" {
  description = "DNS record. Each item can contains keys: 'host_record'(The host record of the domain record.),'type'(The type of the domain. Valid values: A, NS, MX, TXT, CNAME, SRV, AAAA, CAA, REDIRECT_URL, FORWORD_URL. Default to A.),'priority'(The priority of domain record. Valid values are `[1-10]`. When the `type` is `MX`, this parameter is required.),'ttl'(The ttl of the domain record. Default to 600.),'line'(The resolution line of domain record. Default value is default.)."
  type        = map(string)
  default = {
    host_record = "wordpress"
    type        = "A"
    ttl         = 600
    priority    = 1
    line        = "default"
  }
}