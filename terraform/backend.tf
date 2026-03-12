terraform {
  backend "s3" {
    # Required parameters
    bucket = "app-s3-backend"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"

    # Optional parameters
    encrypt      = true
    use_lockfile = true # Alternative to dynamodb_table, available in newer Terraform versions
  }
}
