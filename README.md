# Projeto First Go Application

Este projeto tem como intuito implementar uma aplicação WEB rodando em GO para o Processo Seletivo da Serasa Experian. A Infraestrutura e aplicação serão criados dentro da Amazon AWS.

# Video Auto Explicativo

<https://ratafonso.wistia.com/medias/1h0z8kz9cy>

## Pre-Requisitos de Ambiente

- Ter uma conta gratuita na AWS Amazon;
- Instalação do AWS CLI (<https://aws.amazon.com/pt/cli/>);
- Instalação do VSCode ou outro editor de preferência (<https://code.visualstudio.com/download>);
- Instalação do Git (<https://git-scm.com/downloads>);
- Instalação do WSL2 caso esteja usando Windows (<https://docs.microsoft.com/en-us/windows/wsl/install-win10>)
- Instalação do Terraform (<https://www.terraform.io/downloads.html>)
- Instalação do Ansible (<https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html>)

## Primeiros Passos

Nessa etapa iremos construir a infraestrutura necessária para hospedar a aplicação.

## Configurando o ambiente

Crie um Diretório para receber os arquivos da aplicação localizados no GitHUB.

### Windows

```mkdir webapp```

```cd C:\webapp```

### Linux

```# mkdir /usr/src/webapp```

```# cd /usr/src/webapp```

Execute a clonagem do repositório Git no diretório ```webapp```.

```git clone https://github.com/ratafonso/webapp.git```

Execute a inicialização do terraform dentro do diretório da aplicação

```# terraform init```

Execute o comando para validar a criação da Infraestrutura via Terraform

```# terraform plan```

Após a validação sem erros, execute o comando para iniciar a criação da Infraestrutura via Terraform

```# terraform apply```

=========================================================================================================

Utilize o comando do Docker Compose para subir os containers. É necessário rodar esse comando dentro do diretório da aplicação.

```docker-compose -f "docker-compose.yaml" up -d --build```

Acesse o endereço <http://localhost> para acessar a página inicial da aplicação Web.

Para baixar o ambiente, executar o comando abaixo.

```docker-compose -f "docker-compose.yaml" down```
