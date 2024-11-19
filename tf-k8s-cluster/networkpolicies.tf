module "network_policies" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-networkpolicies"

  namespaces_policies = [{
    front_namespace = "pro-homepage-front"
    back_namespace  = "pro-homepage-back"
  }]
}
