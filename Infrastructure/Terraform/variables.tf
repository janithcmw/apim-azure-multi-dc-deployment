# -------------------------------------------------------------------------------------
#
# Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

# Cluster variables
variable "project" {
  description = "Name of the project"
  type        = string
}

variable "application_name" {
  description = "Application name of the resource"
  type        = string
}

variable "environment" {
  description = "environment that the resource is deployed"
  type        = string
}

variable "hub_spoke" {
  description = "Hub or Spoke"
  type        = string
}

variable "cluster1_padding" {
  default = "001"
  description = "Unique padding for clarity"
  type        = string
}

variable "cluster2_padding" {
  default = "002"
  description = "Unique padding for clarity"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID for the Azure account"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags of the AKS cluster"
  type        = map(string)
}

variable "cluster1_aks_cluster_dns_prefix" {
  default = "cst-aks1"
  description = "AKS cluster dns prefix"
  type        = string
}

variable "cluster2_aks_cluster_dns_prefix" {
  default = "cst-aks2"
  description = "AKS cluster dns prefix"
  type        = string
}

variable "location" {
  description = "Location identifier"
  type        = string
}

# Global AKS Configuration
variable "aks_admin_username" {
  description = "Admin Username for AKS nodes"
  type        = string
}

variable "aks_public_ssh_key_path" {
  description = "Public key path for AKS Nodes"
  type        = string
}

# Cluster network profile
variable "outbound_type" {
  default     = "userDefinedRouting"
  description = "Outbound type for the AKS cluster. Can be loadBalancer or userDefinedRouting"
  type        = string
}

variable "cluster1_service_cidr" {
  description = "CIDR block for allocating K8S Services"
  type        = string
}

variable "cluster1_dns_service_ip" {
  description = "DNS service IP Address"
  type        = string
}

variable "cluster2_service_cidr" {
  description = "CIDR block for allocating K8S Services"
  type        = string
}

variable "cluster2_dns_service_ip" {
  description = "DNS service IP Address"
  type        = string
}

variable "private_cluster_enabled" {
  default     = false
  description = "Enable private access to the cluster's API Server"
  type        = bool
}

# Default Nodepool Configurations
variable "default_node_pool_vm_size" {
  description = "VM Size for the default nodepool"
  type        = string
}

variable "default_node_pool_os_disk_size_gb" {
  description = "OS Disk size of the nodes of the default nodepool"
  type        = number
}

variable "default_node_pool_enable_auto_scaling" {
  default     = true
  description = "Flag to enable auto scaling for the default nodepool"
  type        = bool
}

variable "default_node_pool_max_count" {
  description = "Maximum nodes for default nodepool when used with autoscaling"
  type        = number
}

variable "default_node_pool_min_count" {
  description = "Minimum nodes for default nodepool when used with autoscaling"
  type        = number
}

variable "default_node_pool_name" {
  default = "akspool"
  description = "Default node pool name"
  type        = string
}

variable "default_node_pool_availability_zones" {
  description = "Availability zones for the nodes of the default nodepool"
  type        = list(number)
  default     = []
}

variable "cluster1_aks_node_pool_subnet_address_prefix" {
  description = "Subnet CIDR for deploying the Nodepool"
  type        = string
}

variable "cluster2_aks_node_pool_subnet_address_prefix" {
  description = "Subnet CIDR for deploying the Nodepool"
  type        = string
}

variable "aks_node_pool_subnet_route_table_name" {
  description = "Route table name of AKS node pool"
  type        = string
  default     = "Routing-table-for-AKS-node-pool"
}

variable "default_node_pool_only_critical_addons_enabled" {
  description = "Flag to only use default nodepool for Critical workloads"
  type        = bool
  default     = false
}

variable "default_node_pool_count" {
  description = "Number of nodes for the default system nodepool"
  type        = string
}

variable "cluster1_internal_loadbalancer_subnet_address_prefix" {
  description = "CIDR block of the internal load balancer subnet"
  type        = string
}

variable "cluster2_internal_loadbalancer_subnet_address_prefix" {
  description = "CIDR block of the internal load balancer subnet"
  type        = string
}

variable "azure_policy_enabled" {
  description = "Flag to enable Azure policies for the cluster"
  type        = bool
  default     = false
}

variable "default_node_pool_orchestrator_version" {
  description = "Kubernetes version for the default nodepool"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes"
  type        = string
}

variable "default_node_pool_max_pods" {
  description = "Max number of pods to run on a single node in the default nodepool"
  type        = number
}

variable "internal_load_balancer_subnet_enforce_private_link_endpoint_network_policies" {
  default     = "Disabled"
  description = "Enable or Disable network policies for the private link endpoint on the internal load balancer subnet"
  type        = string
}

variable "private_dns_zone_name" {
  default = "am.wso2.com"
  description = "The dns name of the Aks cluster private DNS."
  type = string
}

variable "cluster1_aks_node_pool_subnet_nsg_rules" {
  default     = {}
  description = "NSG rules for the nodepool subnet"
  type = map(object({
    priority                                   = string
    name                                       = string
    description                                = string
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_ranges                         = list(string)
    destination_port_ranges                    = list(string)
    source_address_prefixes                    = list(string)
    destination_address_prefixes               = list(string)
    source_application_security_group_ids      = list(string)
    destination_application_security_group_ids = list(string)
  }))
}

variable "cluster1_aks_load_balancer_subnet_nsg_rules" {
  default     = {}
  description = "NSG rules for the load balancer subnet"
  type = map(object({
    priority                                   = string
    name                                       = string
    description                                = string
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_ranges                         = list(string)
    destination_port_ranges                    = list(string)
    source_address_prefixes                    = list(string)
    destination_address_prefixes               = list(string)
    source_application_security_group_ids      = list(string)
    destination_application_security_group_ids = list(string)
  }))
}

variable "cluster2_aks_node_pool_subnet_nsg_rules" {
  default     = {}
  description = "NSG rules for the nodepool subnet"
  type = map(object({
    priority                                   = string
    name                                       = string
    description                                = string
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_ranges                         = list(string)
    destination_port_ranges                    = list(string)
    source_address_prefixes                    = list(string)
    destination_address_prefixes               = list(string)
    source_application_security_group_ids      = list(string)
    destination_application_security_group_ids = list(string)
  }))
}

variable "cluster2_aks_load_balancer_subnet_nsg_rules" {
  default     = {}
  description = "NSG rules for the load balancer subnet"
  type = map(object({
    priority                                   = string
    name                                       = string
    description                                = string
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_ranges                         = list(string)
    destination_port_ranges                    = list(string)
    source_address_prefixes                    = list(string)
    destination_address_prefixes               = list(string)
    source_application_security_group_ids      = list(string)
    destination_application_security_group_ids = list(string)
  }))
}

variable "bastion_vm_name" {
  default = "bastion_vm"
  description = "vm name connected to bastion."
  type = string
}

variable "bastion_vm_size" {
  default = "Standard_B1s"
  description = "vm size that is used to ssh"
  type = string
}

variable "bastion_admin_username" {
  default = "bastionuser"
  description = "user name for the bastion VM."
  type = string
}

variable "bastion_public_ssh_key_path" {
  default = "./ssh/id_rsa.pub"
  description = "The public key that is used to connect to bastion vm."
  type  = string
}

variable "bastion_computer_name" {
  default = "bastion.vm"
  description = "The hostname of the bastion vm."
  type = string
}

variable "bastion_vm_subnet_name" {
  default = "bastion-vm-snet"
  description = "Name of the bastion VM."
  type  = string
}

variable "bastion_nsg_name" {
  default = "bastion-nsg"
  description = "The name of the bastion nsg."
  type = string
}

variable "bastion_vm_nic_name" {
  default = "bastion_vm_nic"
  description = "The name of the bastion nic."
  type = string
}

# Variables to access the shared resources.
variable "subscription_id_shared" {
  description = "Subscription ID for the Azure account that contains the test VMs."
  type        = string
}

variable "vnet_name_shared" {
#  default = "vnet-<prefix>-hub-prod-eastus-shared-001"
  description = "The vnet name of the test VMs."
  type = string
}

variable "resource_group_name_shared" {
#  default = "rg-<prefix>-prod-westeurope-shared-001"
  description = "The vnet name of the test VMs."
  type = string
}

# Variables to attach ACR.
variable "acr_name" {
  default = "CSTimage"
  description = "The ACR that store the images."
  type = string
}

variable "acr_resource_group" {
  default = "rg-cst-api-app"
  description = "The ACR that store the images."
  type = string
}