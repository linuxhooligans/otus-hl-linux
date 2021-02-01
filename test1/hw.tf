terraform {
  required_providers {
    ah = {
      source = "advancedhosting/ah"
      version = "0.1.3"
    }
    null = {
      source = "hashicorp/null"
      version = "3.0.0"
    }
  }
}

provider "ah" {
  access_token = var.access_token
}

resource "ah_ssh_key" "example" {
  name = "SSH key Name"
  public_key = file("~/.ssh/id_rsa.pub")
}

# output "test" {
#   value=ah_ssh_key.example.id
# }

# resource "null_resource" "example1" {
#   provisioner "local-exec" {
#     command = "echo ${ah_ssh_key.example.id} > ~/testterraformaction"
#   }
#   depends_on = [
#       ah_ssh_key.example,
#   ]
# }


resource "ah_cloud_server" "example" {
  count = 2
  name = "sample_server_${count.index}"
  datacenter = "ams1"
  image = "centos-7-x64"
  product = var.product
  ssh_keys = [ah_ssh_key.example.id]
  depends_on = [
    ah_ssh_key.example,
  ]

}


# output "ipList" {
#   value ${var.ipList}
# }

# data "ah_cloud_servers" "example" {
#   count = 2
#   filter {
#     key = "name"
#     values = ["sample_server_${count.index}"]
#   }
# }

# data "ah_ips" "example" {
#   count = 2
#   filter {
#     key = "name"
#     values = ["sample_server_${count.index}"]
#   }
# }


locals {

 ipsLocals="${flatten(ah_cloud_server.example.*.ips)}"

}

output "test" {
  value=local.ipsLocals.*.ip_address
}

# resource "null_resource" "example1" {
#   count    = "${length(ah_cloud_server.example)}"
#   private-ip = "${ah_cloud_server.example.*.ips.0.ip_address[count.index]}"
# }

# output "test" {
#     value = "${ah_cloud_server.example.*.ips.0.ip_address[count.index]}"
#
# }
### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
   {
     ip_address = local.ipsLocals.*.ip_address
     ansible_user = var.ansible_user
     StrictHostKeyChecking = var.StrictHostKeyChecking
   }
 )
  filename = var.path_to_inventory
}


resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "ansible-playbook ${var.path_to_playbook} -i ${var.path_to_inventory}"
  }
  depends_on = [
    local_file.AnsibleInventory,
  ]
}

# data "template_file" "dev_hosts" {
#   template = "${file("${path.module}/dev_hosts.cfg")}"
#   depends_on = [
#     ah_cloud_server.example
#   ]
#   count    = "${length(ah_cloud_server.example)}"
#   vars = {
#     # ip_public = "${ah_cloud_server.example.ips.*.ip_address}"
#     ip_public = "${ah_cloud_server.example.*.ips.0.ip_address[count.index]}"
#   }
# }
#
# resource "null_resource" "dev-hosts" {
#   triggers = {
#     template_rendered = "${data.template_file.dev_hosts.rendered}"
#   }
#
#   provisioner "local-exec" {
#     command = "echo '${data.template_file.dev_hosts.rendered}' > dev_hosts"
#   }
# }

#
# output "test2" {
#   value = data.template_file.dev_hosts
# }

#
# resource "null_resource" "example1" {
#   provisioner "local-exec" {
#     command = "echo ${var.product} > ~/testterraformaction"
#   }
#   depends_on = [
#     ah_cloud_server.example,
#   ]
# }


# data "ah_cloud_images" "example" {
#   filter {
#     key = "distribution"
#     values = ["Ubuntu", "Debian"]
#   }
#   filter {
#     key = "architecture"
#     values = ["x86_64"]
#   }
#   sort {
#     key = "version"
#     direction = "desc"
#   }
# }
#
# output "test" {
#
# value=ah_cloud_server.example.*
# }
#
# output "test2" {
#   value = data.ah_cloud_images.example.*
# }
