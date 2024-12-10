module "namespaces" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-namespaces"

  namespaces = var.namespaces
}
