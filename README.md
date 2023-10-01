# Terraform Module: ArgoCD with Google Secret Manager Integration

This module provisions ArgoCD, a declarative, GitOps continuous delivery tool for Kubernetes, with secrets stored and managed in Google Secret Manager.

## Resources

1. **random_password.argocd**: Generates a random password for ArgoCD with special characters.
2. **bcrypt_hash.argo**: Hashes the generated password using the bcrypt algorithm.
3. **google_secret_manager_secret.argocd_secret**: Creates a secret in Google Secret Manager to store the ArgoCD password.
4. **google_secret_manager_secret_version.argocd_secret_version**: Creates a version of the ArgoCD password secret.
5. **helm_release.argocd**: Deploys ArgoCD using the Helm chart from the official ArgoCD repository.
6. **data.google_secret_manager_secret_version.github_repo_secret**: Fetches a secret version from Google Secret Manager which contains GitHub repository details.
7. **kubernetes_secret.github_creds**: Creates a Kubernetes secret in the ArgoCD namespace with GitHub credentials.

## Usage

```hcl
module "argocd" {
  source               = "github.com/sabmirsad/terraform-helm-arocd//argocd"
  cluster_name         = var.cluster_name
  location             = var.cluster_location
  project_id           = var.project_id
  region               = var.region
  gh_repo_secret       = var.gh-repo-secret
  argocd_chart_version = "5.46.7"
}
```
## Inputs
argocd_chart_version - (Required) The desired version of the ArgoCD Helm chart to be deployed.
gh_repo_secret - (Required) The secret ID from Google Secret Manager that holds the GitHub repository details.
## Outputs
None defined.

## Dependencies
Ensure that you have the required Terraform providers installed and authenticated:

- random
- bcrypt
- google (for Google Secret Manager)
- helm (for deploying Helm charts)
- kubernetes
## GitHub Repository Secret Format
For the module to function correctly, it expects a JSON object stored as a secret in Google Secret Manager and referenced in variable **gh_repo_secret** with the following format:

```
{
  "githubAppID": "<your-github-app-id>",
  "githubAppInstallationID": "<your-github-app-installation-id>",
  "githubAppPrivateKey": "<your-github-app-private-key>",
  "project": "<your-project-name>",
  "type": "<repository-type>",
  "url": "<repository-url>"
}
```
**Note: Ensure that you replace the placeholder values (<...>) with actual values specific to your GitHub integration. Never store the actual secrets directly in source code.**

### Notes
The argocdServerAdminPassword for ArgoCD is stored in a bcrypt hashed format.
The GitHub credentials used for ArgoCD are fetched from a Google Secret Manager secret.
License
Choose an appropriate license for your module and add details here, for example, "MIT".

## Author
Mirsad Sabovic

