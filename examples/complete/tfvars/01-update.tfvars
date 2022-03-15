###################
# ECS instance
###################
ecs_instance_name          = "update-tf-testacc-instance"
ecs_instance_password      = "YourPassword123!update"
system_disk_size           = 50
private_ip                 = "172.16.0.11"
internet_charge_type       = "PayByBandwidth"
internet_max_bandwidth_out = 20
deletion_protection        = false
force_delete               = true
tags = {
  Name = "updateECS"
}

###################
# slb
###################
slb_name                        = "update-tf-testacc-slb-name"
slb_spec                        = "slb.s2.medium"
bandwidth                       = 20
virtual_server_group_name       = "update-tf-testacc-server-group-name"
instance_port                   = 90
instance_weight_in_server_group = 20
slb_tags = {
  Name = "updateSLB"
}

###################
# dns
###################
dns_record = {
  host_record = "updatewordpress"
  type        = "A"
  ttl         = 1200
  priority    = 2
  line        = "telecom"
}