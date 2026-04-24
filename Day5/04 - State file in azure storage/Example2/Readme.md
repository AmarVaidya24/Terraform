# To run for each envirnment

**DEV**
cd env/dev
terraform init
terraform apply -var-file=dev.tfvars

**PROD**
cd env/prod
terraform init
terraform apply -var-file=prod.tfvars
