resource "azurerm_resource_group" "ai" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure AI (Cognitive Services): OpenAI, Document Intelligence, Language,
# Speech, Translator, Vision - one reusable module, invoked per service.
# -----------------------------------------------------------------------------
module "cognitive" {
  source   = "./modules/cognitive-account"
  for_each = local.cognitive_services

  name                = "${local.name_prefix}-${each.value.name_suffix}"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  kind                = each.value.kind
  sku_name            = each.value.sku_name
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure AI Search
# -----------------------------------------------------------------------------
module "ai_search" {
  source = "./modules/ai-search"

  name                = "${local.name_prefix}-search"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure AI Foundry hub (+ backing storage account and key vault)
# -----------------------------------------------------------------------------
module "ai_foundry" {
  source = "./modules/ai-foundry"

  name                = "${local.name_prefix}-hub"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  tags                = local.common_tags
}

# -----------------------------------------------------------------------------
# Azure Machine Learning workspace (+ storage, key vault, ACR, App Insights)
# -----------------------------------------------------------------------------
module "machine_learning" {
  source = "./modules/machine-learning"

  name                = "${local.name_prefix}-mlw"
  location            = azurerm_resource_group.ai.location
  resource_group_name = azurerm_resource_group.ai.name
  tags                = local.common_tags
}
