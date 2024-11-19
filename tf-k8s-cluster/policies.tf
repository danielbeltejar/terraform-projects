module "policies" {
  source = "github.com/danielbeltejar/terraform-modules.git//tfmod-kubernetes-policies"

  policies = {
    "K8sRequireUser" = {
      name   = "pods-run-as-root-forbidden"
      policy = <<-EOF
        package k8srequireuser

        violation[{"msg": msg}] {
          input.review.object.spec.securityContext.runAsUser == 0
          msg := "Running as root (UID 0) is not allowed"
        }
        violation[{"msg": msg}] {
          input.review.object.spec.securityContext.runAsUser == null
          msg := "runAsUser is not set"
      EOF  
    },
    "K8sForbidPrivilegeEscalation" = {
      name   = "pods-privilege-escalation-forbidden"
      policy = <<-EOF
        package k8sforbidprivilegeescalation

        violation[{"msg": msg}] {
          input.review.object.spec.containers[_].securityContext.allowPrivilegeEscalation == true
          msg := "allowPrivilegeEscalation must be false"
        }
      EOF
    },
    "K8sForbidPrivilegedPod" = {
      name   = "pods-privilege-forbidden"
      policy = <<-EOF
        package forbid-privileged-pods

        violation[{"msg": msg}] {
          input.review.object.spec.containers[_].securityContext.privileged == true
          msg := "privileged pods are not allowed"
      }
      EOF
    },
    "K8sReadonlyRootFilesystem" = {
      name   = "pods-readonly-root-filesystem-required"
      policy = <<-EOF
        package k8sreadonlyrootfilesystem

        violation[{"msg": msg}] {
          input.review.object.spec.containers[_].securityContext.readOnlyRootFilesystem == false
          msg := "readOnlyRootFilesystem must be true"
        }
      EOF
    },
    "K8sForbidHighPrivileges" = {
      name   = "pods-host-pid-ipc-network-forbidden"
      policy = <<-EOF
        package k8sforbidhighprivileges

        violation[{"msg": msg}] {
          input.review.object.spec.hostPID == true
          msg := "hostPID is not allowed"
        }
        violation[{"msg": msg}] {
          input.review.object.spec.hostIPC == true
          msg := "hostIPC is not allowed"
        }
        violation[{"msg": msg}] {
          input.review.object.spec.hostNetwork == true
          msg := "hostNetwork is not allowed"
        }
      EOF
    },
    "K8sForbidHostPath" = {
      name   = "pods-host-path-volumes-forbidden"
      policy = <<-EOF
        package k8sforbidhostpath

        violation[{"msg": msg}] {
          input.review.object.spec.volumes[_].hostPath
          msg := "hostPath volumes are not allowed"
        }
      EOF
    },
    "K8sRequireLimits" = {
      name   = "pods-cpu-memory-limits-required"
      policy = <<-EOF
        package k8srequirelimits

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          container.resources.limits.cpu == null
          msg := "CPU limit must be specified"
        }
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          container.resources.limits.memory == null
          msg := "Memory limit must be specified"
        }
      EOF
    },
    "K8sForbidDefaultNamespace" = {
      name   = "objects-default-namespace-forbidden"
      policy = <<-EOF
      package k8sforbiddefaultnamespace

      violation[{"msg": msg}] {
        input.review.object.metadata.namespace == "default"
        msg := "Objects cannot be created in the 'default' namespace"
      }
    EOF
    },
    # "K8sForbidImagePullPolicyAlways" = {
    #   name   = "pods-imagepullpolicy-always-forbidden"
    #   policy = <<-EOF
    #   package k8sforbidimagepullpolicyalways

    #   violation[{"msg": msg}] {
    #     container := input.review.object.spec.containers[_]
    #     container.imagePullPolicy == "Always"
    #     msg := "imagePullPolicy 'Always' is not allowed"
    #   }
    # EOF
    # },
    #   "K8sEnforceImageRegistry" = {
    #     name   = "pods-approved-image-registry-only"
    #     policy = <<-EOF
    #   package k8senforceimageregistry

    #   violation[{"msg": msg}] {
    #     container := input.review.object.spec.containers[_]
    #     not startswith(container.image, "approved-registry.io/")
    #     msg := sprintf("Image %v must come from 'approved-registry.io'", [container.image])
    #   }
    # EOF
    #   },
    "K8sForbidCapabilities" = {
      name   = "pods-restricted-capabilities"
      policy = <<-EOF
      package k8sforbidcapabilities

      restricted_capabilities := ["SYS_ADMIN", "NET_ADMIN", "SYS_MODULE", "SYS_PTRACE", "SYS_TIME", "SYS_PACCT"]

      violation[{"msg": msg}] {
        container := input.review.object.spec.containers[_]
        capability := container.securityContext.capabilities.add[_]
        restricted_capabilities[_] == capability
        msg := sprintf("Adding '%s' capability is not allowed", [capability])
      }
    EOF
    },
    "K8sRequireIngressTLS" = {
      name   = "ingress-tls-required"
      policy = <<-EOF
      package k8srequireingresstls

      violation[{"msg": msg}] {
        input.review.object.kind == "Ingress"
        not input.review.object.spec.tls
        msg := "Ingress resources must specify TLS"
      }
    EOF
    }
  }
}
