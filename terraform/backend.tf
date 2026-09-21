terraform {
  backend "s3" {
    bucket = "cloudticket-v2-terraform-remote-state"
    key    = "cloud-ticket-v2/terraform.tfstate"
    region = "ap-southeast-2"

    use_lockfile = true
    encrypt      = true
  }
}