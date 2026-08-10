terraform {
  backend "s3" {
    key     = "secrets/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
    use_lockfile = true
  }
}
