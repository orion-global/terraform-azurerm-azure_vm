locals {
  _linux_machine = var.vm_type == "Linux" ? 1 : 0
  _admin_name    = var.admin_name == null ? "adminuser" : var.admin_name
}
