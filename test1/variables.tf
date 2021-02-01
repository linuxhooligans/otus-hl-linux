variable "access_token" {
}
variable "product" {
}
variable "path_to_playbook" {
  default = "./ansible/run_test_job.yml"
}
variable "path_to_inventory" {
  default = "./ansible/inventories/nginx/hosts"
}
variable "ansible_user" {
  default = "adminroot"
}
# variable "ansible_host_key_checking" {
#   default = "false"
# }
variable "StrictHostKeyChecking" {
  default = "no"
}
