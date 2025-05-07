locals {
  yaml_config = yamldecode(file("${path.module}/locals.yaml"))
}