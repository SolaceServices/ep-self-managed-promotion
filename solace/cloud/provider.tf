terraform {
  required_providers {
    solacecloud = {
      source = "solaceproducts/solacecloud"
    }
  }
}

# The API token is read from the SOLACECLOUD_API_TOKEN environment variable.
provider "solacecloud" {
  base_url = "https://api.solace.cloud/"
}
