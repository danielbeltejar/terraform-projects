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
  host             = "https://192.168.1.100:6443"
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
    workspace_dir = "./vars"

    path = "vars/terraform.tfstate"

  }
}
