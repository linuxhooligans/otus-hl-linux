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
  access_token = var.accessToken
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
  # ips        = [
  #               {
  #                 assignment_id = "12.12.12.12"
  #                 ip_address = "12.12.12.12"
  #                 primary = true
  #                 type = "public"
  #                 reverse_dns = "testcount"
  #               }
  #             ]
  depends_on = [
    ah_ssh_key.example,
  ]
}


# output "example" {
#   value = ah_cloud_server.example.0.ips.0.ip_address
# }
#
# resource "ah_ip" "example" {
#
#   count      = var.countCloudServers
#   type = "public"
#   # ip_address = ah_cloud_server.example[count.index].ips.0.ip_address
#   datacenter = var.datacenterCloudServer
#   reverse_dns = "testcount${count.index}.pupup.ru"
#   depends_on = [
#     ah_cloud_server.example,
#   ]
# }



# output "example" {
#   value = ah_cloud_server.example.*
# }


#
# locals {
#   idServer = flatten(ah_cloud_server.example.*.id)
# }
#
# output "example11" {
#   value = ah_cloud_server.example.0.id
# }

# resource "null_resource" "example11" {
#   for_each = local.idServer.*
#
# }

resource "ah_private_network" "example" {
  ip_range = "10.0.0.0/24"
  name = "Private Network for cluster"
  depends_on = [
    ah_cloud_server.example,
  ]
}
#
resource "ah_private_network_connection" "example" {
  count      = var.countCloudServers
  cloud_server_id = ah_cloud_server.example[count.index].id
  private_network_id = ah_private_network.example.id
  ip_address = "10.0.0.${count.index+1}"
  depends_on = [
    ah_cloud_server.example,
    ah_private_network.example
  ]
}

# locals {
#   ipsLocals = flatten(ah_cloud_server.example.*.ips)
#   depends_on = [
#     ah_private_network_connection.example,
#   ]
# }

# locals {
#   ipsLocals = flatten(ah_private_network_connection.example.*.ips)
#   depends_on = [
#     ah_private_network_connection.example,
#   ]
# }

data "ah_cloud_servers" "example" {
  depends_on = [
    ah_private_network_connection.example,
  ]
}

locals {
  inventoryGenerateIps = flatten(data.ah_cloud_servers.example.cloud_servers.*.ips)
  inventoryGeneratePriveteNetworks = flatten(data.ah_cloud_servers.example.cloud_servers.*.private_networks)
  inventoryGenerate = flatten(data.ah_cloud_servers.example.cloud_servers.*)
}

output "example1" {
  # value = ah_private_network_connection.example.*.ip_address
  # depends_on = [
  #   ah_private_network_connection.example,
  # ]
  #value = data.ah_cloud_servers.example.cloud_servers.*
  value = local.inventoryGeneratePriveteNetworks.*.ip
}
output "example2" {
  # value = ah_private_network_connection.example.*.ip_address
  # depends_on = [
  #   ah_private_network_connection.example,
  # ]
  #value = data.ah_cloud_servers.example.cloud_servers.*
  value = local.inventoryGenerateIps.*.reverse_dns
}

output "example3" {
  # value = ah_private_network_connection.example.*.ip_address
  # depends_on = [
  #   ah_private_network_connection.example,
  # ]

  #value = data.ah_cloud_servers.example.cloud_servers.*
  value = flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).*.reverse_dns
}


output "example4" {

  value = flatten(data.ah_cloud_servers.example.cloud_servers.*.private_networks).*.ip
}

output "example5" {

  value =  concat(data.ah_cloud_servers.example.cloud_servers.*.ips,data.ah_cloud_servers.example.cloud_servers.*.private_networks)


}
output "example6" {

  value =  concat(local.inventoryGenerateIps.*.reverse_dns,local.inventoryGeneratePriveteNetworks.*.ip)


}

# variable "subnet_ids" {
#    default = ["subnet-345325", "subnet-345243", "subnet-345234"]
#  }
#
#  variable "cidrs" {
#    default = ["qqq", "10.0.1.0/24", "10.0.2.0/23"]
#  }
#
#  locals  {
#    testMap = zipmap(
#
#
locals  {
  testMap = zipmap(flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).*.reverse_dns,flatten(data.ah_cloud_servers.example.cloud_servers.*.private_networks).*.ip)
}



locals {
  cron= setproduct(flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).*.reverse_dns,flatten(data.ah_cloud_servers.example.cloud_servers.*.private_networks).*.ip)
}


 output "subnet_strings_option_one" {
   value = local.cron
 }




# resource "null_resource" "merge" {
#
#   mergemerge = merge(
#       flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).*.reverse_dns,
#       {
#         EXISTING_ENV = "hello"
#       },
#  )
# }


### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile(var.pathToInventoryTemplate,
    {

        reverse_dns           = flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).*.reverse_dns
        ansible_user          = var.ansible_user
        StrictHostKeyChecking = var.StrictHostKeyChecking
        private_ip            = flatten(data.ah_cloud_servers.example.cloud_servers.*.private_networks).*.ip
        main_server           = flatten(data.ah_cloud_servers.example.cloud_servers.*.ips).0.reverse_dns
    }
  )
  filename = var.pathToInventory
  depends_on = [
    ah_cloud_server.example,
  ]
}

# resource "time_sleep" "wait_60_seconds" {
#   create_duration = "60s"
#   depends_on = [
#     local_file.AnsibleInventory,
#   ]
# }
#### ansible-playbook ./ansible/homework_2.yml -i ./ansible/inventories/nginx/hosts --extra-var passwdHacluster=hapass --extra-var mytest=[{"user":"user1","group":"group1"}]
# resource "null_resource" "example1" {
#   provisioner "local-exec" {
#     command = "${var.pathToAnsiblePlaybookExec} ${var.pathToPlaybook} -i ${var.pathToInventory} --extra-vars 'passwdHacluster=${var.passwdHacluster}' "
#   }
#   depends_on = [
#     time_sleep.wait_60_seconds,
#   ]
# }
