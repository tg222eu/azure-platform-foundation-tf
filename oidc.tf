# =============================================================================
# GitHub OpenID Connect
# =============================================================================

resource "azuread_application" "main" {
  display_name = "github-oidc-platformfoundation"
}