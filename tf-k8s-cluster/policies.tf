module "policies" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-policies"

  policies = var.policies
}
