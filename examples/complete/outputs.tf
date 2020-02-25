##################################
# module market_application_with_dns
##################################
output "this_url_of_market_application_with_dns" {
  description = "The url of web application with binding dns."
  value       = module.market_application_with_dns.this_application_url
}

output "this_instance_id_of_market_application_with_dns" {
  description = "The instance id of web application binding dns."
  value       = module.market_application_with_dns.this_ecs_instancde_id
}

output "this_application_with_dns_slb_virtual_server_group_id" {
  description = "The vritual server group id of web application with dns."
  value       = module.market_application_with_dns.this_slb_virtual_server_group_id
}

output "this_slb_id_of_market_application_with_dns" {
  description = "The slb id of web application binding dns."
  value       = module.market_application_with_dns.this_slb_id
}

output "this_image_id_of_market_application_with_dns" {
  description = "The image id of web application binding dns."
  value       = module.market_application_with_dns.this_ecs_instance_image_id
}

output "this_vswitch_id_of_market_application_with_dns" {
  description = "The vswitch id of web application binding dns."
  value       = module.market_application_with_dns.this_vswitch_id
}

##################################
# module market_application_with_slb
##################################
output "this_url_of_market_application_with_slb" {
  description = "The url of web application with binding slb."
  value       = module.market_application_with_slb.this_application_url
}

output "this_instance_id_of_market_application_with_slb" {
  description = "The instance id of web application binding slb."
  value       = module.market_application_with_slb.this_ecs_instancde_id
}

output "this_application_with_slb_virtual_server_group_id" {
  description = "The virtual server group id of web application with slb."
  value       = module.market_application_with_slb.this_slb_virtual_server_group_id
}

output "this_slb_id_of_market_application_with_slb" {
  description = "The slb id of web application binding slb."
  value       = module.market_application_with_slb.this_slb_id
}

output "this_image_id_of_market_application_with_slb" {
  description = "The image id of web application binding slb."
  value       = module.market_application_with_slb.this_ecs_instance_image_id
}

output "this_vswitch_id_of_market_application_with_slb" {
  description = "The vswitch id of web application binding slb."
  value       = module.market_application_with_slb.this_vswitch_id
}

##################################
# module this_url_of_market_application_with_ecs
##################################
output "this_url_of_market_application_with_ecs" {
  description = "The url of web application instance."
  value       = module.market_application_with_ecs.this_application_url
}

output "this_instance_id_of_market_application_with_ecs" {
  description = "The instance id of web application."
  value       = module.market_application_with_ecs.this_ecs_instancde_id
}

output "this_image_id_of_market_application_with_ecs" {
  description = "The image id of web application instance."
  value       = module.market_application_with_ecs.this_ecs_instance_image_id
}

output "this_vswitch_id_of_market_application_with_ecs" {
  description = "The vswitch id of web application instance."
  value       = module.market_application_with_ecs.this_vswitch_id
}