# locals.tf
locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  standard_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
    },
    var.tags
  )
}
