locals{
    common_tags = {
        Environment = var.environment_name
        Project     = var.project_name
        Owner       = var.owner_name
        ManagedBy   = "Terraform"
        CostCenter  = var.cost_center
    }
    naming_prefix = "${var.project_name}-${var.environment_name}"
}