# Azure Landing Zone

**Personal learning project** – Exploring Azure landing zone patterns using Terraform

### Current Status
This is an early-stage project I started recently to practice Infrastructure as Code concepts.

### What exists so far
- Remote state backend (Azure Blob Storage)
- Resource Group with tagging strategy
- Hub VNet with three segmented subnets (app, data, management)
- Network Security Groups associated to each subnet
- Variable-driven configuration with consistent Azure naming convention

### Goals
- Build foundational Azure resources using Terraform (networking, Key Vault, logging, storage)
- Practice proper project structure, state management and CI/CD
- Learn operational patterns for platform foundations

> Work in progress – more implementation coming soon.
