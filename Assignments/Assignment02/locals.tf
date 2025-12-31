#####################################
# Get public IP dynamically
#####################################
data "http" "my_ip" {
  url = "https://icanhazip.com"
}

#####################################
# Local values
#####################################
locals {

  # Dynamic IP for SSH access
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"

  # Common tags for all resources
  common_tags = {
    Environment = var.env_prefix
    Project     = "Assignment-2"
    ManagedBy   = "Terraform"
  }

  # Naming convention
  name_prefix = "${var.env_prefix}-assignment"

  # Backend servers configuration
  backend_servers = [
    {
      name        = "web-1"
      suffix      = "1"
      script_path = "./scripts/apache-setup.sh"
    },
    {
      name        = "web-2"
      suffix      = "2"
      script_path = "./scripts/apache-setup.sh"
    },
    {
      name        = "web-3"
      suffix      = "3"
      script_path = "./scripts/apache-setup.sh"
    }
  ]
}

