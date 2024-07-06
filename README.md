# Terraform README

Terraform - это инструмент для создания, изменения и управления инфраструктурой безопасным и предсказуемым образом. С его помощью можно описывать инфраструктуру как код (IaC).

## Установка Terraform

### На Ubuntu

1. Обновите список пакетов и установите необходимые зависимости:
   ```bash
   sudo apt update
   sudo apt install -y gnupg software-properties-common curl
   ```

2. Добавьте GPG ключ HashiCorp:
   ```bash
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   ```

3. Добавьте репозиторий HashiCorp:
   ```bash
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   ```

4. Установите Terraform:
   ```bash
   sudo apt update
   sudo apt install terraform
   ```

### На macOS

1. Установите Terraform с помощью Homebrew:
   ```bash
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   ```

## Создание первого проекта с Terraform

### Шаг 1: Инициализация проекта

1. Создайте новую директорию для вашего проекта и перейдите в нее:
   ```bash
   mkdir my-terraform-project
   cd my-terraform-project
   ```

2. Инициализируйте проект:
   ```bash
   terraform init
   ```

### Шаг 2: Описание инфраструктуры

1. Создайте файл `main.tf` и опишите вашу инфраструктуру. Например, для создания экземпляра EC2 на AWS:
   ```hcl
   provider "aws" {
     region = "us-west-2"
   }

   resource "aws_instance" "example" {
     ami           = "ami-0c55b159cbfafe1f0"
     instance_type = "t2.micro"

     tags = {
       Name = "example-instance"
     }
   }
   ```

### Шаг 3: Планирование и применение изменений

1. Запустите команду `terraform plan` для предварительного просмотра изменений, которые будут применены:
   ```bash
   terraform plan
   ```

2. Примените изменения:
   ```bash
   terraform apply
   ```

3. Подтвердите применение изменений, введя `yes` при запросе.

### Шаг 4: Управление инфраструктурой

- Для обновления конфигурации или добавления новых ресурсов, внесите изменения в `main.tf` и повторите шаги `plan` и `apply`.
- Для удаления ресурсов, используйте команду:
  ```bash
  terraform destroy
  ```

## Полезные команды Terraform

- `terraform init` - инициализация нового или существующего Terraform проекта.
- `terraform plan` - создание плана выполнения изменений инфраструктуры.
- `terraform apply` - применение изменений, описанных в планах.
- `terraform destroy` - удаление всех управляемых ресурсов.
- `terraform validate` - проверка конфигурационных файлов на корректность.
- `terraform fmt` - форматирование конфигурационных файлов Terraform.
- `terraform show` - отображение состояния или плана инфраструктуры.
- `terraform state` - управление состоянием Terraform.

## Управление состоянием

Terraform хранит состояние вашей инфраструктуры в файле `terraform.tfstate`. Этот файл необходим для корректного управления ресурсами. Для командной работы и предотвращения конфликтов рекомендуется хранить состояние в удаленном хранилище (например, в S3 или HashiCorp Consul).

### Пример настройки удаленного хранилища в AWS S3:

1. Добавьте блок `backend` в `main.tf`:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "my-terraform-state-bucket"
       key            = "path/to/my/key"
       region         = "us-west-2"
       dynamodb_table = "my-lock-table"
     }
   }
   ```

2. Инициализируйте проект заново для применения изменений:
   ```bash
   terraform init
   ```

## Заключение

Terraform - мощный инструмент для управления инфраструктурой как кодом. Этот README представляет базовое введение в использование Terraform. Для более сложных сценариев и конфигураций рекомендуется ознакомиться с [официальной документацией Terraform](https://www.terraform.io/docs).
