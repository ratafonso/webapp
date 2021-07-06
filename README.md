# Projeto First Go Application

Este projeto tem como intuito implementar uma aplicação WEB rodando em GO para o Processo Seletivo da Serasa Experian. A Infraestrutura e aplicação serão criados dentro da Amazon AWS.

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

Lembre-se de configurar as suas credenciais de acesso ao ambiente da AWS através do comando ```aws configure```. É necessário criar uma key pair para que o terraform se conecte a AWS. É possível gerar essa chave executando o comando ```ssh-keygen```, serão geradas duas chaves dentro do seu home, uma com a extensão .pub (Chave Pública) e outra sem extensão (Chave Privada), copie o conteúdo da chave .pub gerada anteriormente. Abra a console da AWS, Pesquise por EC2. No Painel EC2, localize Key Pairs a sua esquerda. vá em Acções/Importar Key Pair, coloque um nome para esta chave e apóse cole o conteúdo copiado anteriormente dentro da Text Box, ou navegue até aonde o arquivo se encontra. Finalize clicando em Import Key Pair.

### Windows

```mkdir webapp```

```cd C:\webapp```

### Linux

```# mkdir /webapp```

```# cd /webapp```

Execute a clonagem do repositório Git no diretório ```webapp```.

```git clone https://github.com/ratafonso/webapp.git```

Altere a variável "key_name" localizada dentro do arquivo "main.tf" para a chave Key Pair gerada anteriormente. Coloque o nome que ficou definido nas etapas anteriores.

Execute a inicialização do terraform dentro do diretório da aplicação

```# terraform init```

Execute o comando para validar a criação da Infraestrutura via Terraform

```# terraform plan```

Após a validação sem erros, execute o comando para iniciar a criação da Infraestrutura via Terraform

```# terraform apply```

=========================================================================================================

Após a Infraestrutura já estar criada, acesse a sua console da AWS e copie o Public DNS Name ou o Public IP da sua instância EC2, iremos precisar dela para seguir para os próximos passos.

Com a chave SSH gerada anteriormente, utilize um client SSH para acessar a sua instância EC2.

ssh -i <chavessh> ubuntu@nomedainstancia

Acesse o diretório clonado do repositório e siga as etapas abaixo:

Utilize o comando do Docker Compose para subir os containers. É necessário rodar esse comando dentro do diretório da aplicação.

```docker-compose -f "docker-compose.yaml" up -d --build```

Acesse o endereço <http://localhost> para acessar a página inicial da aplicação Web.

Para baixar o ambiente, executar o comando abaixo.

```docker-compose -f "docker-compose.yaml" down```
