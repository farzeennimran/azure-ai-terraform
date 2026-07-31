locals {
  # ---------------------------------------------------------------------------
  # Naming convention
  #   Pattern: {org}-{environment}-{region}-{service}
  #   Example: bh-prd-eus-openai  /  bh-prd-eus-ai-rg
  # ---------------------------------------------------------------------------
  region_codes = {
    "East US"      = "eus"
    "East US 2"    = "eus2"
    "Central US"   = "cus"
    "West US"      = "wus"
    "West US 2"    = "wus2"
    "West Europe"  = "weu"
    "North Europe" = "neu"
  }
  region_code = local.region_codes[var.location]

  name_prefix         = "${var.org}-${var.environment}-${local.region_code}"
  resource_group_name = "${local.name_prefix}-ai-rg"

  # ---------------------------------------------------------------------------
  # Tags applied to every resource. var.tags is merged last, so per-deployment
  # values can extend or override these baseline tags.
  # ---------------------------------------------------------------------------
  environment_names = {
    dev = "Development"
    tst = "Test"
    stg = "Staging"
    prd = "Production"
  }

  common_tags = merge(
    {
      Environment = local.environment_names[var.environment]
      ManagedBy   = "Terraform"
      Workload    = "AI"
    },
    var.tags,
  )

  # ---------------------------------------------------------------------------
  # Azure AI (Cognitive Services) accounts. All six share the one reusable
  # cognitive-account module and differ only by kind, SKU, and name, so they
  # are defined here and deployed with a single for_each'd module in main.tf.
  # ---------------------------------------------------------------------------
  cognitive_services = {
    openai = {
      kind        = "OpenAI"
      sku_name    = "S0"
      name_suffix = "openai"
    }
    document_intelligence = {
      kind        = "FormRecognizer"
      sku_name    = "S0"
      name_suffix = "docintel"
    }
    language = {
      kind        = "TextAnalytics"
      sku_name    = "S"
      name_suffix = "language"
    }
    speech = {
      kind        = "SpeechServices"
      sku_name    = "S0"
      name_suffix = "speech"
    }
    translator = {
      kind        = "TextTranslation"
      sku_name    = "S1"
      name_suffix = "translator"
    }
    vision = {
      kind        = "ComputerVision"
      sku_name    = "S1"
      name_suffix = "vision"
    }
  }
}
