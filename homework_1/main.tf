terraform {
  required_providers {
    ah = {
      source  = "advancedhosting/ah"
      version = "0.1.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
  }
}

provider "ah" {
  access_token = var.access_token
}

resource "ah_ssh_key" "example" {
  name       = var.namePublicKey
  public_key = file(var.pathToPublicKey)
}

resource "ah_cloud_server" "example" {
  count      = var.countCloudServers
  name       = "${var.patternCloudServerName}_${count.index}"
  datacenter = var.datacenterCloudServer
  image      = var.imageCloudServer
  product    = var.productCloudServer
  ssh_keys   = [ah_ssh_key.example.id]
  depends_on = [
    ah_ssh_key.example,
  ]

}

locals {
  ipsLocals = flatten(ah_cloud_server.example.*.ips)
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile(var.pathToInventoryTemplate,
    {
      ip_address            = local.ipsLocals.*.ip_address
      ansible_user          = var.ansible_user
      StrictHostKeyChecking = var.StrictHostKeyChecking
    }
  )
  filename = var.path_to_inventory
}

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "${var.pathToAnsiblePlaybook} ${var.path_to_playbook} -i ${var.path_to_inventory}"
  }
  depends_on = [
    local_file.AnsibleInventory,
  ]
}
