locals{
    common_tags = {
        Environment = var.environment
        Project     = "PlatformFoundation"
        Owner       = var.owner
        ManagedBy   = "Terraform"
        CostCenter  = var.cost_center
    }
}