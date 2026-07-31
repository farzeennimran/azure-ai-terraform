# Azure AI Services — Terraform

Modular Terraform for provisioning a suite of **Azure AI services** into a single
resource group, following a consistent `{org}-{environment}-{region}-{service}`
naming convention.

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-844FBA?logo=terraform&logoColor=white)
![Azure Provider](https://img.shields.io/badge/azurerm-~%3E4.0-0078D4?logo=microsoftazure&logoColor=white)

---

## Overview

- **One reusable module for six Cognitive Services.** Azure OpenAI, Document
  Intelligence, Language, Speech, Translator, and Vision are all
  `azurerm_cognitive_account` resources that differ only by `kind` and SKU. They
  are defined as a map in `locals.tf` and deployed with a single `for_each`'d
  module — adding a service is one map entry, not a new folder.
- **Single shared resource group.** The root creates one resource group and
  passes its name and location into every module. Modules never create resource
  groups.
- **Providers configured once.** The `azurerm` provider is declared only at the
  root; modules pin provider versions but inherit the root provider.
- **Centralised naming and tags.** All names and common tags are derived in
  `locals.tf`, so the whole deployment is driven from a handful of variables.

## What gets deployed

| Service | Module | Azure resource | `kind` | Default SKU | Example name |
| --- | --- | --- | --- | --- | --- |
| Azure OpenAI | `cognitive-account` | `azurerm_cognitive_account` | `OpenAI` | `S0` | `bh-prd-eus-openai` |
| Document Intelligence | `cognitive-account` | `azurerm_cognitive_account` | `FormRecognizer` | `S0` | `bh-prd-eus-docintel` |
| Language | `cognitive-account` | `azurerm_cognitive_account` | `TextAnalytics` | `S` | `bh-prd-eus-language` |
| Speech | `cognitive-account` | `azurerm_cognitive_account` | `SpeechServices` | `S0` | `bh-prd-eus-speech` |
| Translator | `cognitive-account` | `azurerm_cognitive_account` | `TextTranslation` | `S1` | `bh-prd-eus-translator` |
| Vision | `cognitive-account` | `azurerm_cognitive_account` | `ComputerVision` | `S1` | `bh-prd-eus-vision` |
| AI Search | `ai-search` | `azurerm_search_service` | — | `basic` | `bh-prd-eus-search` |
| AI Foundry hub | `ai-foundry` | `azurerm_ai_foundry` (+ storage, key vault) | — | — | `bh-prd-eus-hub` |
| Machine Learning | `machine-learning` | `azurerm_machine_learning_workspace` (+ storage, key vault, ACR, App Insights) | — | — | `bh-prd-eus-mlw` |

## Repository structure

```
.
├── main.tf              # Resource group + module calls
├── locals.tf            # Naming convention, common tags, cognitive-services map
├── variables.tf         # Root input variables
├── outputs.tf           # Aggregated outputs
├── providers.tf         # azurerm provider configuration (root only)
├── versions.tf          # Terraform + provider version constraints
├── terraform.tfvars     # Example values (replace before use)
└── modules/
    ├── cognitive-account/   # Reusable module for all six Cognitive Services
    ├── ai-search/           # Azure AI Search service
    ├── ai-foundry/          # AI Foundry hub + backing storage & key vault
    └── machine-learning/    # ML workspace + storage, key vault, ACR, App Insights
```

## Naming convention

Resource names are composed in `locals.tf` from the pattern:

```
{org}-{environment}-{region}-{service}
```

For example, with `org = "bh"`, `environment = "prd"`, and `location = "East US"`:

- Resource group → `bh-prd-eus-ai-rg`
- Azure OpenAI → `bh-prd-eus-openai`
- AI Search → `bh-prd-eus-search`

The region short code is looked up from `location` via a map, so the region is
set in one place only:

| `location` | Code |
| --- | --- |
| East US | `eus` |
| East US 2 | `eus2` |
| Central US | `cus` |
| West US | `wus` |
| West US 2 | `wus2` |
| West Europe | `weu` |
| North Europe | `neu` |

Deploying to a region not in the map fails at plan time by design — add a row to
`region_codes` in `locals.tf` to support it.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) **>= 1.5**
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (used for
  authentication)
- An Azure subscription with permission to create the resources above
  (Contributor or equivalent)
- The following resource providers registered on the subscription:
  `Microsoft.CognitiveServices`, `Microsoft.Search`,
  `Microsoft.MachineLearningServices`, `Microsoft.Storage`,
  `Microsoft.KeyVault`, `Microsoft.ContainerRegistry`, `Microsoft.Insights`

## Getting started

```bash
# 1. Clone
git clone <your-repo-url>
cd <repo>

# 2. Authenticate
az login
az account set --subscription "<your-subscription-id>"

# 3. Configure
#    Edit terraform.tfvars and set subscription_id (and org / environment /
#    location if the defaults don't suit you).

# 4. Deploy
terraform init
terraform plan
terraform apply
```

By default the `azurerm` provider uses your Azure CLI credentials. For CI/CD, use
a service principal via the `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`,
`ARM_TENANT_ID`, and `ARM_SUBSCRIPTION_ID` environment variables.

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :---: |
| `subscription_id` | Azure subscription ID to deploy the AI services into | `string` | — | **yes** |
| `org` | Organisation / business-unit prefix used in resource names | `string` | `"bh"` | no |
| `environment` | Environment code used in resource names (`dev`, `tst`, `stg`, `prd`) | `string` | `"prd"` | no |
| `location` | Azure region for all resources | `string` | `"East US"` | no |
| `tags` | Additional tags merged on top of the common tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| --- | --- |
| `resource_group_name` | Name of the resource group holding all AI services |
| `cognitive_account_endpoints` | Map of Cognitive Services endpoints keyed by service |
| `cognitive_account_ids` | Map of Cognitive Services resource IDs keyed by service |
| `search_service_url` | Azure AI Search endpoint URL |
| `ai_foundry_id` | ID of the Azure AI Foundry hub |
| `machine_learning_workspace_id` | ID of the Azure Machine Learning workspace |

## Modules

| Module | Purpose | Key resources created |
| --- | --- | --- |
| `cognitive-account` | Reusable Cognitive Services account | `azurerm_cognitive_account` with a system-assigned identity |
| `ai-search` | Azure AI Search service | `azurerm_search_service` |
| `ai-foundry` | AI Foundry hub and its dependencies | Storage account, key vault, access policy, `azurerm_ai_foundry` |
| `machine-learning` | ML workspace and its dependencies | Storage account, key vault, access policy, Application Insights, container registry, ML workspace |

<details>
<summary><strong>Module inputs & outputs (click to expand)</strong></summary>

All modules share the same core interface — `name`, `location`,
`resource_group_name`, and `tags` — plus the module-specific settings below.

### `cognitive-account`

| Input | Type | Default |
| --- | --- | --- |
| `name` | `string` | — |
| `location` | `string` | — |
| `resource_group_name` | `string` | — |
| `kind` | `string` | — |
| `sku_name` | `string` | `"S0"` |
| `custom_subdomain_name` | `string` | `null` (defaults to `name`) |
| `public_network_access_enabled` | `bool` | `true` |
| `tags` | `map(string)` | `{}` |

**Outputs:** `name`, `endpoint`, `resource_id`, `principal_id`

### `ai-search`

| Input | Type | Default |
| --- | --- | --- |
| `name` | `string` | — |
| `location` | `string` | — |
| `resource_group_name` | `string` | — |
| `sku` | `string` | `"basic"` |
| `replica_count` | `number` | `1` |
| `partition_count` | `number` | `1` |
| `local_authentication_enabled` | `bool` | `true` |
| `tags` | `map(string)` | `{}` |

**Outputs:** `search_service_name`, `search_service_id`, `search_service_url`

### `ai-foundry`

| Input | Type | Default |
| --- | --- | --- |
| `name` | `string` | — |
| `location` | `string` | — |
| `resource_group_name` | `string` | — |
| `key_vault_sku_name` | `string` | `"standard"` |
| `storage_account_tier` | `string` | `"Standard"` |
| `storage_account_replication_type` | `string` | `"LRS"` |
| `soft_delete_retention_days` | `number` | `7` |
| `tags` | `map(string)` | `{}` |

**Outputs:** `ai_foundry_name`, `ai_foundry_id`, `principal_id`,
`storage_account_name`, `key_vault_name`

### `machine-learning`

| Input | Type | Default |
| --- | --- | --- |
| `name` | `string` | — |
| `location` | `string` | — |
| `resource_group_name` | `string` | — |
| `key_vault_sku_name` | `string` | `"standard"` |
| `storage_account_tier` | `string` | `"Standard"` |
| `storage_account_replication_type` | `string` | `"LRS"` |
| `container_registry_sku` | `string` | `"Basic"` |
| `application_insights_type` | `string` | `"web"` |
| `soft_delete_retention_days` | `number` | `7` |
| `tags` | `map(string)` | `{}` |

**Outputs:** `workspace_name`, `workspace_id`, `storage_account_name`,
`container_registry_name`, `application_insights_name`, `key_vault_name`

</details>

## Adding a new Cognitive Service

Add an entry to the `cognitive_services` map in `locals.tf` — no new files needed:

```hcl
face = {
  kind        = "Face"
  sku_name    = "S0"
  name_suffix = "face"
}
```

Then run `terraform apply`. The service is created as
`{org}-{environment}-{region}-face` and its endpoint/ID appear in the
`cognitive_account_endpoints` and `cognitive_account_ids` outputs.

## Notes and caveats

- **Global name uniqueness.** Cognitive Services, Storage, Key Vault, and
  Container Registry names must be unique across all of Azure. Storage, key
  vault, and ACR names include a random suffix; if a Cognitive Services account
  name ever collides, change its `name_suffix` in `locals.tf`.
- **Key vault soft-delete.** Key vaults are created with purge protection
  enabled. After `terraform destroy` they enter a soft-deleted state and cannot
  be purged until the retention period elapses, which can block re-creating a
  vault with the same name.
- **State backend.** This configuration uses local state by default. For team
  use, configure a remote backend (e.g. an `azurerm` backend backed by a storage
  account) before applying.

## Cleanup

```bash
terraform destroy
```
