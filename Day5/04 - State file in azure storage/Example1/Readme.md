# command to create storage account

Correct order:

✅ Create storage account & container (using az commands)
✅ Configure backend.tf
✅ Run terraform init

# 1. Create infrastructure first

```bash
az group create --name rg-tf-backend --location eastus
az storage account create --name sttfbackend123 --resource-group rg-tf-backend --location eastus --sku Standard_RAGRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false
az storage container create --name tfstate --account-name sttfbackend123
```

# Verify it exists before terraform init

```bash
az storage account show --name sttfbackend123 --resource-group rg-tf-backend
```

# 2. Then initialize Terraform

```bash
cd "C:\Teraform\Terraform\Day5\04 - State file in azure storage\Example1"
terraform init
```

# Step 1: Create a resource group

```bash
az group create --name rg-tf-backend --location eastus
```

# Step 2: Create the storage account

```bash
az storage account create --name sttfbackend123 --resource-group rg-tf-backend --location eastus --sku Standard_RAGRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false
```

```bash
az storage account create --name sttfbackend123 --resource-group rg-tf-backend --location eastus --sku Standard_RAGRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false
```

# Step 3: Create blob container for state files

```bash
az storage container create --name tfstate --account-name sttfbackend123
```

Key parameters:

--name: Storage account name (must be globally unique, lowercase, 3-24 chars)
--resource-group: Resource group name
--location: Azure region (eastus, westus, etc.)
--sku: Standard_LRS, Standard_GRS, Standard_RAGRS, etc.
--kind: StorageV2, BlobStorage, FileStorage
--min-tls-version: TLS1_0, TLS1_1, or TLS1_2 (security)
--allow-blob-public-access: true/false (public access control)

# for delete resource.

```bash
az group delete --name rg-tf-backend --yes --no-wait
```
