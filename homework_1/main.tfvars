### Cloud server config block
countCloudServers = "2"
imageCloudServer = "centos-7-x64"
datacenterCloudServer = "ams1"
productCloudServer = "start-xs"
patternCloudServerName = "sample_server"
pathToInventoryTemplate = "inventory.tmpl"

### SSH block
pathToPublicKey = "~/.ssh/id_rsa.pub"
namePublicKey = "SSH key Name"

### Ansible block
pathToAnsiblePlaybookExec = "ansible-playbook"
pathToPlaybook = "./ansible/run_test_job.yml"
pathToInventory= "./ansible/inventories/nginx/hosts"
### FYI -> Не сохранил camelCase стилистику чтобы не запутаться при генерации шаблона
ansible_user = "adminroot"
StrictHostKeyChecking= "no"
