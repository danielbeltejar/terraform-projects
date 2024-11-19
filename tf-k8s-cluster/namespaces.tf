module "namespaces" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-namespaces"

  namespaces = [
    {
      name = "pro-bigmac-index"
    },
    {
      name = "pro-emoji-translator"
    },
    {
      name = "pro-frontyardmonsters"
    },
    {
      name = "pro-gustusapp-back"
    },
    {
      name = "pro-gustusapp-front"
    },
    {
      name = "pro-homepage-back"
    },
    {
      name = "pro-homepage-front"
    },
    {
      name = "pro-jf-callejero"
    },
    {
      name = "pro-jf-homepage"
    },
    {
      name = "pro-jf-tfg-back"
    },
    {
      name = "pro-minemines-front"
    },
    {
      name = "pro-nextcloud"
    },
    {
      name = "pro-photoprism"
    },
    {
      name = "pro-pokemon-weather-map-back"
    },
    {
      name = "pro-pokemon-weather-map-front"
    },
    {
      name = "pro-wordpress-blog"
    },
    {
      name = "pro-clicus-metrics-back"
    },
    {
      name = "pro-clicus-metrics-front"
    },
    {
      name = "kube-hunter"
    }
  ]
}
