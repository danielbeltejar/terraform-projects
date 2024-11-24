module "network_policies" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-networkpolicies"

  namespaces_policies = var.namespaces_policies
}
