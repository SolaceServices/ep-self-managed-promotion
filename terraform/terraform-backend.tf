terraform {
  backend "s3" {
    encrypt      = true
    use_lockfile = true                              # S3-native locking (Terraform 1.10+)
  }
}