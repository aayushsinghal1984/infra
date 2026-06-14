
locals {
  tags = {
    Application      = "myappp"
    ApplicationOwner = "myappowner"
    BusinessOwner    = "Iambusinnesowner"
    CIID             = "SDGG55554"
    CostCenter       = "85475"
    CreatedBy        = "014785@hyg.com"
    Enviroment       = "POC"
    PmCostCenter     = "65474"
    Stakholder       = "abcd,hyg@gmail.com"
  }
}

resource "azurerm_log_analytics_workspace" "logws" {
    for_each = var.aks
  name                = each.value.aks_log_analytic_name
  location            = each.value.rg_location
  resource_group_name = data.azurerm_resource_group.rg_block[each.key].name
  sku                 = each.value.sku
  retention_in_days   = each.value. retention_in_days
}

data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "res-0" {
    for_each=var.aks
    depends_on = [
    azurerm_log_analytics_workspace.logws
  ]
  automatic_upgrade_channel           = each.value.automatic_upgrade_channel != "" ? each.value.automatic_upgrade_channel : null
  azure_policy_enabled                = each.value.azure_policy_enabled 
  cost_analysis_enabled               = each.value.cost_analysis_enabled   
  custom_ca_trust_certificates_base64 = length(each.value.custom_ca_trust_certificates_base64) > 0 ? each.value.custom_ca_trust_certificates_base64 : []
  disk_encryption_set_id              = each.value.disk_encryption_set_id != "" ? each.value.disk_encryption_set_id : null
  dns_prefix                          = each.value.dns_prefix 
  dns_prefix_private_cluster          = each.value.dns_prefix_private_cluster != "" ? each.value.dns_prefix_private_cluster : null
  edge_zone                           = each.value.edge_zone != "" ? each.value.edge_zone : null
  http_application_routing_enabled    = each.value.http_application_routing_enabled
  # image_cleaner_enabled               = each.value.image_cleaner_enabled
  # image_cleaner_interval_hours        = each.value.image_cleaner_interval_hours 
  kubernetes_version                  = each.value.kubernetes_version
  local_account_disabled              = each.value.local_account_disabled   
  location                            = each.value.rg_location
  name                                = each.value.aks_name
  node_os_upgrade_channel             = each.value.node_os_upgrade_channel 
  node_resource_group                 = each.value.node_resource_group   
  oidc_issuer_enabled                 = each.value.oidc_issuer_enabled 
  open_service_mesh_enabled           = each.value.open_service_mesh_enabled
  private_cluster_enabled             = each.value.private_cluster_enabled  
  private_cluster_public_fqdn_enabled = each.value.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = each.value.private_dns_zone_id != "" ? each.value.private_dns_zone_id : null
  resource_group_name                 = data.azurerm_resource_group.rg_block[each.key].name
  role_based_access_control_enabled   = each.value.role_based_access_control_enabled
  run_command_enabled                 = each.value.run_command_enabled
  sku_tier                            = each.value.sku_tier 
  # support_plan                        = each.value.support_plan 
   tags = local.tags
  workload_identity_enabled           = each.value.workload_identity_enabled
  auto_scaler_profile {
    balance_similar_node_groups                   = each.value.balance_similar_node_groups
    daemonset_eviction_for_empty_nodes_enabled    = each.value.daemonset_eviction_for_empty_nodes_enabled
    daemonset_eviction_for_occupied_nodes_enabled = each.value.daemonset_eviction_for_occupied_nodes_enabled
    empty_bulk_delete_max                         = each.value.empty_bulk_delete_max  
    expander                                      = each.value.expander   
    ignore_daemonsets_utilization_enabled         = each.value.ignore_daemonsets_utilization_enabled  
    max_graceful_termination_sec                  = each.value.max_graceful_termination_sec 
    max_node_provisioning_time                    = each.value.max_node_provisioning_time 
    max_unready_nodes                             = each.value.max_unready_nodes 
    max_unready_percentage                        = each.value.max_unready_percentage      
    new_pod_scale_up_delay                        = each.value.new_pod_scale_up_delay 
    scale_down_delay_after_add                    = each.value.scale_down_delay_after_add  
    scale_down_delay_after_delete                 = each.value.scale_down_delay_after_delete  
    scale_down_delay_after_failure                = each.value.scale_down_delay_after_failure
    scale_down_unneeded                           = each.value.scale_down_unneeded 
    scale_down_unready                            = each.value.scale_down_unready
    scale_down_utilization_threshold              = each.value.scale_down_utilization_threshold 
    scan_interval                                 = each.value.scan_interval 
    skip_nodes_with_local_storage                 = each.value.skip_nodes_with_local_storage  
    skip_nodes_with_system_pods                   = each.value.skip_nodes_with_system_pods
  }
  azure_active_directory_role_based_access_control{
    admin_group_object_ids=[]
    azure_rbac_enabled= each.value.azure_rbac_enabled
    tenant_id = data.azurerm_client_config.current.tenant_id


  }
  default_node_pool {
    auto_scaling_enabled          = each.value.auto_scaling_enabled  
    capacity_reservation_group_id = each.value.capacity_reservation_group_id != "" ? each.value.capacity_reservation_group_id : null
    fips_enabled                  = each.value.fips_enabled 
    #gpu_driver                    = each.value.gpu_driver != "" ? each.value.gpu_driver : null
    gpu_instance                  = each.value.gpu_instance != "" ? each.value.gpu_instance : null
    host_encryption_enabled       = each.value.host_encryption_enabled
    host_group_id                 = each.value.host_group_id != "" ? each.value.host_group_id : null
    kubelet_disk_type             = each.value.kubelet_disk_type
    max_count                     = each.value.max_count 
    max_pods                      = each.value.max_pods  
    min_count                     = each.value.min_count
    name                          = each.value.node_pool_name
    node_count                    = each.value.node_count  
    node_labels                   = length(each.value.node_labels) > 0 ? each.value.node_labels : {}
    node_public_ip_enabled        = each.value.node_public_ip_enabled 
    node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id != "" ? each.value.node_public_ip_prefix_id : null
    only_critical_addons_enabled  = each.value.only_critical_addons_enabled
    orchestrator_version          = each.value.orchestrator_version 
    os_disk_size_gb               = each.value.os_disk_size_gb
    os_disk_type                  = each.value.os_disk_type 
    os_sku                        = each.value.os_sku 
    pod_subnet_id                 = each.value.pod_subnet_id != "" ? each.value.pod_subnet_id : null
    proximity_placement_group_id  = each.value.proximity_placement_group_id != "" ? each.value.proximity_placement_group_id : null
    scale_down_mode               = each.value.scale_down_mode
    snapshot_id                   = each.value.snapshot_id != "" ? each.value.snapshot_id : null
    tags                          = length(each.value.tags) > 0 ? each.value.tags : {}
    temporary_name_for_rotation   = each.value.temporary_name_for_rotation != "" ? each.value.temporary_name_for_rotation : null
    type                          = each.value.default_node_pool_type
    ultra_ssd_enabled             = each.value.ultra_ssd_enabled 
    vm_size                       = each.value.vm_size
    vnet_subnet_id                = data.azurerm_subnet.subnet_block[each.key].id
     workload_runtime              = each.value.workload_runtime != "" ? each.value.workload_runtime : null
     zones                          = length(each.value.zones) > 0 ? each.value.zones : []
    upgrade_settings {
      drain_timeout_in_minutes      = each.value.drain_timeout_in_minutes != 0 ? each.value.drain_timeout_in_minutes : null
      max_surge                     = each.value.max_surge 
       node_soak_duration_in_minutes = each.value.node_soak_duration_in_minutes != 0 ? each.value.node_soak_duration_in_minutes : null
    }
  }
  identity {
   identity_ids = length(each.value.identity_ids) > 0 ? each.value.identity_ids : []
    type         = each.value.type
  }
    network_profile {
    dns_service_ip      = each.value.dns_service_ip
    ip_versions         = each.value.ip_versions 
    load_balancer_sku   = each.value.load_balancer_sku 
    network_data_plane  = each.value.network_data_plane
    network_mode       = contains(["bridge", "transparent"], each.value.network_mode) ? each.value.network_mode : "transparent"
    network_plugin      = each.value.network_plugin
    network_plugin_mode = each.value.network_plugin_mode
    network_policy      = contains(["azure", "calico", "cilium"], each.value.network_policy) ? each.value.network_policy : null
    outbound_type       = each.value.outbound_type 
    pod_cidr            = each.value.pod_cidr   

    pod_cidrs           = each.value.pod_cidrs  
    service_cidr        = each.value.service_cidr 
    service_cidrs       = each.value.service_cidrs   
    load_balancer_profile {
      backend_pool_type           = each.value.backend_pool_type 
      idle_timeout_in_minutes     = each.value.idle_timeout_in_minutes  
       managed_outbound_ip_count   = each.value.managed_outbound_ip_count
       managed_outbound_ipv6_count = lookup(each.value, "managed_outbound_ipv6_count", null) >= 1 ? each.value.managed_outbound_ipv6_count : null
     # outbound_ip_address_ids     = length(each.value.outbound_ip_address_ids) > 0 ? each.value.outbound_ip_address_ids : []
     #  outbound_ip_prefix_ids      = length(each.value.outbound_ip_prefix_ids) > 0 ? each.value.outbound_ip_prefix_ids : []
     #  outbound_ports_allocated    = each.value.outbound_ports_allocated != 0 ? each.value.outbound_ports_allocated : null
        }
   
  }
 oms_agent {
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.logws[each.key].id
  msi_auth_for_monitoring_enabled = each.value.msi_auth_for_monitoring_enable
}

  windows_profile {
    admin_password = each.value.admin_password
    admin_username = each.value.admin_username 
    #  license        = length(each.value.license) > 0 ? each.value.license : ""
  }
}
