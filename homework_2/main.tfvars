### Cloud server config block
countCloudServers = "3"
imageCloudServer = "centos-8-x64"
datacenterCloudServer = "ams1"
productCloudServer = "start-xs"
patternCloudServerName = "cluster-server"
patternCloudDomainName = "example.com"
pathToInventoryTemplate = "inventory.tmpl"

### SSH block
pathToPublicKey = "~/.ssh/id_rsa.pub"
namePublicKey = "SSH key Name"

### Ansible block
pathToAnsiblePlaybookExec = "ansible-playbook"
pathToPlaybook = "./ansible/homework_2.yml"
pathToInventory= "./ansible/inventories/nginx/hosts"
### FYI -> Не сохранил camelCase стилистику чтобы не запутаться при генерации шаблона
ansible_user = "adminroot"
StrictHostKeyChecking= "no"
