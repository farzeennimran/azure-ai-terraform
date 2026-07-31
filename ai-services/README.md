# Azure AI Services (Modular Terraform)

Modular Terraform for a suite of Azure AI services deployed into a single
resource group, following a `{org}-{environment}-{region}-{service}` naming
convention.

## Structure

```
.
├── main.tf              # Resource group + module calls
├── locals.tf            # Naming convention, common tags, cognitive-services map
├── variables.tf         # Root input variables
├── outputs.tf           # Aggregated outputs
├── providers.tf         # azurerm provider configuration (root only)
├── versions.tf          # Terraform + provider version constraints
├── terraform.tfvars     # Example values (replace subscription_id)
└── modules/
    ├── cognitive-account/   # Reusable: OpenAI, Document Intelligence,
    │                        # Language, Speech, Translator, Vision
    ├── ai-search/           # Azure AI Search service
    ├── ai-foundry/          # AI Foundry hub + storage + key vault
    └── machine-learning/    # ML workspace + storage + KV + ACR + App Insights
```

## Key design points

- **One resource group.** The root creates a single RG and passes its name and
  location into every module. Modules never create resource groups.
- **Providers live at the root only.** Modules declare `required_providers`
  (version constraints) but never a `provider` block, so they inherit the root
  provider.
- **Six cognitive services, one module.** OpenAI, Document Intelligence,
  Language, Speech, Translator, and Vision are all `azurerm_cognitive_account`
  resources that differ only by `kind` and SKU. They are defined as a map in
  `locals.tf` and deployed with a single `for_each`'d module in `main.tf`.

## Usage

```bash
# Set your subscription ID in terraform.tfvars first.
terraform init
terraform plan
terraform apply
```

## Notes

- Cognitive Services, Storage, Key Vault, and Container Registry names must be
  **globally unique**. The `bh-prd-eus-*` prefix plus a random suffix (for
  storage/KV/ACR) makes collisions unlikely; if a cognitive account name
  collides, adjust the `name_suffix` values in `locals.tf`.
- Add regions to the `region_codes` map in `locals.tf` as you expand. An
  unmapped `location` fails at plan time by design.
