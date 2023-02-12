# Terraform self containing cloud provisioning
IoC example of cloud infrastructure with repositories and backends

## Authenticate
#### with user account
```shell
az login
az account show --output table
az account set --subscription "__"
```
#### with service principal and secret
use `.env` file with Environment Variables `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID` and `ARM_TENANT_ID`.

## Build
```shell
terraform plan
```

## Format
```shell
terraform fmt
```

## Deploy
```shell
terraform apply --auto-approve
```

## Migrate
#### from local state files to remote backend
```shell
terraform init -migrate-state
```

## Test

### Secutity
#### tfsec
```shell
docker run --rm --volume $(pwd)/src:/src --volume $(pwd)/tmp:/tmp aquasec/tfsec:latest /src --debug --format default,lovely,JSON,SARIF,CSV,CheckStyle,JUnit,text,Gif --out /tmp/tfsec
```

### links:
- [Naming convention abbreviations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Naming resource rules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
- [Microsoft Graph App and Scope permissions.](https://matthewdavis111.com/msgraph/azure-ad-permission-details/)
- [450+ Creative And Best Software Team Names Ideas](https://namesbee.com/software-team-names/)
- [The Good, the Bad, and the Ugly of Using Terraform-Compliance](https://adinermie.com/the-good-the-bad-and-the-ugly-of-using-terraform-compliance/)
- [Publishing TFSec Terraform Quality Checks to Azure DevOps Pipelines](https://adinermie.com/publishing-tfsec-terraform-quality-controls-to-azure-devops-pipelines/)
