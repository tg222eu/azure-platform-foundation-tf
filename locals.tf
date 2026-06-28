locals{
    common_tags = {
        Environment = var.environment
        Project     = "LandingZone"
        Owner       = var.owner
        ManagedBy   = "Terraform"
        CostCenter  = var.cost_center
    }
}