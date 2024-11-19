module "helm_packages" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-helm-packages"

  kubeconfig = file("~/.kube/config")

  helm_charts = [
    # {
    #   name        = "nginx"
    #   chart       = "nginx"
    #   repository  = "https://charts.bitnami.com/bitnami"
    #   namespace   = "ingress-nginx"
    #   version     = "18.2.4"
    #   values_file = "/dev/null"
    # },
    {
      name        = "longhorn"
      chart       = "longhorn"
      repository  = "https://charts.longhorn.io"
      namespace   = "longhorn-system"
      version     = "1.7.2"
      values_file = "files/longhorn.values.yaml"
    },
    {
      name        = "gatekeeper"
      chart       = "gatekeeper"
      namespace   = "gatekeeper-system"
      repository  = "https://open-policy-agent.github.io/gatekeeper/charts"
      version     = "3.17.1"
      values_file = "files/gatekeeper.values.yaml"
    },
    {
      name        = "vault"
      chart       = "vault"
      repository  = "https://helm.releases.hashicorp.com"
      namespace   = "vault-system"
      version     = "0.29.0"
      values_file = "files/vault.values.yaml"
    },
    {
      name        = "argocd"
      chart       = "argo-cd"
      repository  = "https://argoproj.github.io/argo-helm"
      namespace   = "argocd-system"
      version     = "7.7.3"
      values_file = "files/argocd.values.yaml"
    },
    {
      name        = "cilium"
      chart       = "cilium"
      repository  = "https://helm.cilium.io/"
      namespace   = "kube-system"
      version     = "1.16.3"
      values_file = "files/cilium.values.yaml"
    },
    {
      name        = "harbor"
      chart       = "harbor"
      repository  = "https://helm.goharbor.io"
      namespace   = "harbor-system"
      version     = "1.15.1"
      values_file = "files/harbor.values.yaml"
    }
  ]
}
