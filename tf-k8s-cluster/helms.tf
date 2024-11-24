module "helm_packages" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-helm-packages"

  kubeconfig = file("~/.kube/config")

  helm_charts = var.helm_charts
}
