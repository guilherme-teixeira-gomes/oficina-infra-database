# Oficina Infra Database

Infraestrutura como Código do banco de dados gerenciado — Tech Challenge Fase 3 (Grupo MotorMind).

## Propósito

Provisiona via Terraform:

- **VPC compartilhada** (10.0.0.0/16) com subnets públicas e privadas em 2 AZs
- **RDS PostgreSQL 15** gerenciado (db.t3.micro — free tier)
- **Security Group** restringindo acesso à porta 5432
- **DB Subnet Group** nas subnets privadas

A VPC é criada neste repositório e exportada via remote state para o repositório `oficina-infra-k8s` consumir.

## Tecnologias

- Terraform >= 1.5
- AWS RDS PostgreSQL 15
- Backend S3 para estado remoto

## Arquitetura

```
┌─────────────────────── VPC 10.0.0.0/16 ───────────────────────┐
│                                                                │
│  ┌── public-a (10.0.101.0/24) ──┐  ┌── public-b (10.0.102.0/24)│
│  │   Load Balancers             │  │                           │
│  └──────────────────────────────┘  └───────────────────────────│
│                                                                │
│  ┌── private-a (10.0.1.0/24) ───┐  ┌── private-b (10.0.2.0/24) │
│  │   ┌─────────────────────┐    │  │                           │
│  │   │  RDS PostgreSQL 15  │◄───┼──┼── porta 5432 (SG)         │
│  │   └─────────────────────┘    │  │                           │
│  └──────────────────────────────┘  └───────────────────────────│
└────────────────────────────────────────────────────────────────┘
```

## Recursos criados

| Recurso | Descrição |
|---------|-----------|
| aws_vpc | VPC 10.0.0.0/16 compartilhada |
| aws_subnet (x4) | 2 públicas + 2 privadas em 2 AZs |
| aws_internet_gateway | Saída para internet das subnets públicas |
| aws_db_subnet_group | Grupo de subnets privadas para o RDS |
| aws_security_group | Firewall — porta 5432 restrita |
| aws_db_instance | PostgreSQL 15, 20GB, backups de 7 dias |

## Como aplicar

### Pré-requisitos

1. Conta AWS com credenciais configuradas
2. Bucket S3 para o estado: `aws s3 mb s3://oficina-terraform-state`

### Localmente

```bash
terraform init
terraform plan -var="db_password=SUA_SENHA"
terraform apply -var="db_password=SUA_SENHA"
```

### Via CI/CD

O pipeline executa automaticamente:

- **Pull Request** → `terraform fmt`, `validate` e `plan`
- **Push na main** → `terraform apply` automático

Secrets necessários no GitHub: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (se aplicável), `DB_PASSWORD`.

## Outputs

| Output | Consumido por |
|--------|---------------|
| db_endpoint | Aplicação e Lambda |
| vpc_id | oficina-infra-k8s |
| private_subnet_ids | oficina-infra-k8s (nodes) |
| public_subnet_ids | oficina-infra-k8s (load balancers) |

## Destruir (controle de custos)

```bash
terraform destroy -var="db_password=SUA_SENHA"
```
