locals {
  _linux_machine = var.vm_type == "Linux" ? 1 : 0
}
