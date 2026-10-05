# Bootstrap intentionally uses local state because it creates the remote backend.
terraform {
  backend "local" {}
}
