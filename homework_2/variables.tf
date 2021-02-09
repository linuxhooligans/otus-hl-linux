### WARNING use the sensitive.tfvars file to define this variable
variable "accessToken" {
}

### Cloud server config block
variable "countCloudServers" {
  default = "3"
}
variable "imageCloudServer" {
  default = "centos-8-x64"
}
variable "patternCloudServerName" {
  default = "sample_server"
}
variable "datacenterCloudServer" {
  default = "ams1"
}
variable "pathToInventoryTemplate" {
  default = "inventory.tmpl"
}
variable "productCloudServer" {
  default = "start-xs"
}

### SSH block
variable "pathToPublicKey" {
  default = "~/.ssh/id_rsa.pub"
}
variable "namePublicKey" {
  default = "SSH key Name"
}

### Ansible block
variable "pathToAnsiblePlaybookExec" {
  default = "ansible-playbook"
}
variable "pathToPlaybook" {
  default = "./ansible/homework_2.yml"
}
variable "pathToInventory" {
  default = "./ansible/inventories/nginx/hosts"
}
#Не сохранил camelCase стилистику чтобы не запутаться при генерации шаблона
variable "ansible_user" {
  default = "adminroot"
}
variable "StrictHostKeyChecking" {
  default = "no"
}


### Hacluster
variable "passwdHacluster" {
  default = "default"
}
