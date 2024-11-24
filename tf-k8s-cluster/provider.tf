provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {

  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  load_config_file = true
  config_path      = pathexpand("~/.kube/config")
}

terraform {

  required_providers {
    helm = {
      version = "~> 2.16"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "local" {
    workspace_dir = "./states"

    path = "states/terraform.tfstate"

  }
}
