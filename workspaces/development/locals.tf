/**
 * Local Values
 * This file imports values from locals.yaml
 */

locals {
  yaml_config = yamldecode(file("${path.module}/locals.yaml"))
}