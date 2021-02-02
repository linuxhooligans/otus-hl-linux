
### Homework 1
*otus-hl-linux by Oleg Inishev aka Linux Hooligans*

### Инструкция
Для проверки домашнего задания выполните последовательно следующие действия

1. Передайте файлы данного репозитория на машину с которой будет выполняться проверка домашнего задания.  
  <pre><code>git clone  https://github.com/linuxhooligans/otus-hl-linux.git</code></pre>

2. Перейдите в папку с домашним заданием **homework_1**
  <pre><code>cd ./otus-hl-linux/homework_1  </code></pre>

3. Создайте в директории **homework_1** файл **sensitive.tfvars**
  <pre><code> echo "accessToken = \"\" " > ./sensitive.tfvars  </code></pre>
  и введите свой *access_token*  от сервиса advancedhosting.
  Скопировать или создать token можно перейдя по URL https://websa.advancedhosting.com/api


4. Отредактируйте  файл **main.tfvars**  учитывая описанное ниже назначение переменных

**countCloudServers** -  *Количество серверов которое будет создано при раскатке*
**imageCloudServer** - *Версия образа ОС которая будет установлена на создаваемых серверах*
**datacenterCloudServer** - *Датацентр в котором будут созданы сервера*
**productCloudServer** - *Название тарифа/конфигурация серверов*
**patternCloudServerName** - *Префикс названия серверов*
**pathToInventoryTemplate** - *Путь и название файла шаблона inventory. На основе данного шаблона будет создан файл inventory, который будет использоваться на этапе провижинга ansible*

**pathToPublicKey** - *Путь до файла публичного ключа, который будет разложен на создаваемые сервера для аутентификации*
**namePublicKey** - *Имя с которым будет добавлен публичный ключ*


**pathToAnsiblePlaybookExec** - *Полный путь до команды ansible-playbook. Whereis в помощь*
**pathToPlaybook** - *Путь до ansible playbook, который будет запускаться на этапе провижинга* "./ansible/run_test_job.yml"
**pathToInventory** - *Путь до ansible inventory, который генериться на основе шаблона определенного в pathToInventoryTemplate*

**ansible_user** - *Имя пользователя, от имени которого выполняется подключение к серверам, на этапе провижинга, при работе ansible. FYI -> Не сохранил camelCase стилистику чтобы не запутаться при генерации шаблона*
**StrictHostKeyChecking** - *Параметр определяющий выполнять ли проверку RSA отпечатка, на этапе провижинга, при работе ansible, при подключении к серверам по SSH*



5. Выполните команду
   <pre><code> terraform init </code></pre>

6. Выполните команду
   <pre><code> terraform apply -var-file="./sensitive.tfvars"  -var-file="./main.tfvars" </code></pre>
   где *./sensitive.tfvars* - файл созданный на 3м шаге
   и   *./main.tfvars* - файл заполенный на 4м шаге

*P.S. Если возникнут вопросы пишите в telegram @linuxhooligans https://t.me/linuxhooligans*   
