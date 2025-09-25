# Azure DevOps & GitHub Actions CI/CD Demo

This project demonstrates a complete CI/CD workflow for a Node.js "Hello World" web application deployed to Azure App Service, using:
- **GitHub Actions** for infrastructure provisioning with Terraform
- **Azure DevOps Pipeline** for application build, test, and deployment

---

## Project Structure

```
azure-devops-assignment/
├── app.js                # Node.js Express web app
├── package.json          # Node.js dependencies and scripts
├── test.js               # Simple test suite
├── infra/
│   └── main.tf           # Terraform code for Azure infrastructure
├── .github/
│   └── workflows/
│       └── terraform-infra.yml  # GitHub Actions workflow for Terraform
├── azure-pipelines.yml   # Azure DevOps pipeline for CI/CD
└── README.md             # Project documentation
```

---

## 1. Infrastructure Provisioning (GitHub Actions + Terraform)

- **Workflow:** `.github/workflows/terraform-infra.yml`
- **Code:** `infra/main.tf`
- **Resources Created:**
  - Resource Group
  - App Service Plan (Linux)
  - Azure App Service (Node.js)

### Setup
1. Add the following secrets to your GitHub repository:
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_TENANT_ID`
2. On push to `main` (or manual trigger), the workflow will:
   - Initialize Terraform
   - Validate and apply the configuration
   - Provision Azure resources

---

## 2. Application CI/CD (Azure DevOps Pipeline)

- **Pipeline:** `azure-pipelines.yml`
- **Stages:**
  - Build: Installs dependencies, runs tests, prepares artifacts
  - Deploy: Deploys to the App Service created by Terraform

### Setup
1. Create an Azure DevOps pipeline using `azure-pipelines.yml`.
2. Set pipeline variables for:
   - `azureSubscription` (Service connection name)
   - `resourceGroupName` (should match Terraform)
   - `appServiceName` (should match Terraform)
3. On push to `main` or `develop`, the pipeline will:
   - Build and test the Node.js app
   - Deploy the app to Azure App Service

---

## 3. Application Overview

- **Main endpoint:** `/` (Hello World HTML page)
- **Health check:** `/health` (JSON status)
- **API endpoint:** `/api/info` (App info)
- **Tests:** `test.js` (can be run with `npm test`)

---

## 4. How It Works

1. **Provision Infra:**
   - GitHub Actions runs Terraform to create Azure resources.
2. **Deploy App:**
   - Azure DevOps pipeline builds/tests the app and deploys to the App Service.
3. **Access App:**
   - Find the app URL in the Azure Portal under the App Service resource.

---

## 5. Useful Commands

### Local Development
```bash
npm install
npm start
```

### Run Tests
```bash
npm test
```

### Terraform (from `infra/` folder)
```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## 6. Links & References
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions for Terraform](https://github.com/hashicorp/setup-terraform)
- [Azure DevOps Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)

---

## 7. Security & Best Practices
- Never commit secrets to source control.
- Use GitHub/Azure DevOps secrets for credentials.
- Review and restrict permissions for service principals.
- Use least privilege for all Azure resources.

---

## 8. Authors
- Azure DevOps Assignment
