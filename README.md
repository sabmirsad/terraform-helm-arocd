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
  "project": "default",
  "type": "git",
  "url": "<repository-url>"
}
```
**Note: Ensure that you replace the placeholder values (<...>) with actual values specific to your GitHub integration. Never store the actual secrets directly in source code.**

### Notes
The argocdServerAdminPassword for ArgoCD is stored in a bcrypt hashed format.
The GitHub credentials used for ArgoCD are fetched from a Google Secret Manager secret.
## License
GPL-3.0 license

## Author
Mirsad Sabovic

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_bcrypt"></a> [bcrypt](#requirement\_bcrypt) | >= 0.1.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.8 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.17 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_bcrypt"></a> [bcrypt](#provider\_bcrypt) | >= 0.1.2 |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.8 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.17 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [bcrypt_hash.argo](https://registry.terraform.io/providers/viktorradnai/bcrypt/latest/docs/resources/hash) | resource |
| [google_secret_manager_secret.argocd_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.argocd_secret_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.github_creds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.argocd](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [google_secret_manager_secret_version.github_repo_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | Argocd chart version to be deployed | `string` | n/a | yes |
| <a name="input_argocd_values"></a> [argocd\_values](#input\_argocd\_values) | helm values for argocd | `list` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name for the GKE cluster | `string` | n/a | yes |
| <a name="input_gh_repo_secret"></a> [gh\_repo\_secret](#input\_gh\_repo\_secret) | The json object with fields needed to confiure argocd github repo using gh app | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The node locations for the GKE node pool | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID of your project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host the cluster in | `string` | n/a | yes |

## Outputs

No outputs.
