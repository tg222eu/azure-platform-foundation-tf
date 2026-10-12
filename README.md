# Azure Platform Foundation

**Personal learning project** – Exploring Azure Platform Foundation patterns using Terraform

### Current Status
This is an early-stage project I started recently to practice Infrastructure as Code concepts.

README FILE IN-PROGRESS

Bootstrap OICD

For CI/CD to work we have to solve the chicken-and-egg problem: GitHub Actions cannot deploy until an Azure identity already exists and already has permission, but Terraform cannot create that identity until Actions can deploy.

In an enterprise setup this first layer usually lives in a dedicated repo, for example azure-oidc-bootstrap. That repo would create the App Registration, federated credentials, state storage, and the first RBAC assignments. After that, every real project repo only uses the identity.

In this lab I did the same job in the portal instead. Functionally it is the same bootstrap. (Dedicated repo later as a mini project?)

I created App registration github-oidc-lab

GitHub Secrets 

AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID

Federation identity

![alt text](https://raw.githubusercontent.com/tg222eu/azure-platform-foundation-tf/refs/heads/main/images/federate.png)

The OIDC subjects used
```
repo:<owner>@<orgId>/<repo>@<repoId>:ref:refs/heads/main
repo:<owner>@<orgId>/<repo>@<repoId>:ref:pull_request
```
Best practice for this CI pattern is to register both OIDC subjects: one for main and one for pull_request. The pull_request subject is only used when a workflow is triggered by a pull request. In the workflow YAML, on: pull_request: is a reserved GitHub event. Writing it with no extra options uses the default: run on all pull requests.
