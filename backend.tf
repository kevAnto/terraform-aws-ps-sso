terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kevanto"

    workspaces {
      prefix = "ps-sso-"
    }
  }
}
