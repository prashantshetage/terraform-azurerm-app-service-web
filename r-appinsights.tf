data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

resource "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id == null ? 1 : 0

  name                = local.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name

  application_type = var.application_insights_type

  tags = merge(
    local.default_tags,
    var.extra_tags,
    {
      format("hidden-link:%s", local.app_service_id) = "Resource"
    },
  )
}
