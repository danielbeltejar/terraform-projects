module "helm_packages" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-helm-packages"

  helm_charts = var.helm_charts
}
