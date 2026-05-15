Azure Hub-Spoke Terraform scaffold

This scaffold provisions an Azure Hub-Spoke topology inspired by the provided diagram.

Included resources (minimal, extend as needed):

- Resource Group
- Hub Virtual Network with `AppGatewaySubnet` and `GatewaySubnet`
- Application Gateway (basic/http listener)
- Virtual Network Gateway (VPN)
- Two Spoke VNets (Prod & Test) with `frontend` and `backend` subnets
- VNet peerings between hub and spokes
- Network Security Groups for subnets
- Example Azure SQL Server & Database (admin credentials required)

Quick start:

1. Copy `terraform.tfvars.example` → `terraform.tfvars` and fill required values.
2. Run:

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

Notes:

- This is a minimal starting point. Add certificates, backend pools, and more secure settings before production use.

Architecture diagram:

The following image shows the Hub-and-Spoke architecture used by this project. Save the provided diagram image as `diagram.png` in this folder (`Day5/azure-hub-spoke/`) so it displays here.

![Hub and Spoke Architecture](./diagram.png)

If you prefer a different filename or path, update the markdown image path above accordingly.
