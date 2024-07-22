## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "wordpress" {
  source                    = "github.com/oracle-devrel/terraform-oci-arch-wordpress"
  tenancy_ocid              = var.tenancy_ocid
  vcn_id                    = oci_core_virtual_network.wpmdsvcn.id
  numberOfNodes             = var.numberOfNodes
  availability_domain       = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  compartment_ocid          = var.compartment_ocid
  image_id                  = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  shape                     = var.node_shape
  flex_shape_ocpus          = var.node_flex_shape_ocpus
  flex_shape_memory         = var.node_flex_shape_memory
  label_prefix              = var.label_prefix
  use_shared_storage        = var.use_shared_storage
  display_name              = "wordpress"
  wp_subnet_id              = oci_core_subnet.wp_subnet.id
  lb_subnet_id              = var.numberOfNodes > 1 ? oci_core_subnet.lb_subnet_public[0].id : ""
  bastion_subnet_id         = (var.numberOfNodes > 1 && var.use_bastion_service == false) ? oci_core_subnet.bastion_subnet_public[0].id : ""
  fss_subnet_id             = var.numberOfNodes > 1 && var.use_shared_storage ? oci_core_subnet.fss_subnet_private[0].id : ""
  ssh_authorized_keys       = var.ssh_public_key
  mds_ip                    = module.mds-instance.mysql_db_system.ip_address
  admin_password            = var.admin_password
  admin_username            = var.admin_username
  wp_auto_update            = var.wp_auto_update
  wp_schema                 = var.wp_schema
  wp_version                = var.wp_version
  wp_name                   = var.wp_name
  wp_password               = var.wp_password
  wp_plugins                = tolist(split(",",var.wp_plugins))
  wp_themes                 = tolist(split(",",var.wp_themes))
  wp_site_title             = var.wp_site_title
  wp_site_admin_user        = var.wp_site_admin_user
  wp_site_admin_pass        = var.wp_site_admin_pass
  wp_site_admin_email       = var.wp_site_admin_email
  lb_shape                  = var.numberOfNodes > 1 ? var.lb_shape : ""
  flex_lb_min_shape         = var.numberOfNodes > 1 ? var.flex_lb_min_shape : ""
  flex_lb_max_shape         = var.numberOfNodes > 1 ? var.flex_lb_max_shape : ""
  use_bastion_service       = var.use_bastion_service
  bastion_image_id          = lookup(data.oci_core_images.InstanceImageOCID2.images[0], "id")
  bastion_shape             = var.bastion_shape
  bastion_flex_shape_ocpus  = var.bastion_flex_shape_ocpus
  bastion_flex_shape_memory = var.bastion_flex_shape_memory
  bastion_service_region    = var.numberOfNodes > 1 ? var.region : ""
  defined_tags              = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
