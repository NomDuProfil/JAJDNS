/*

# Author information

Name: NomDuProfil
Website: valou.io

# Module information

This module will create an EC2 Instance for DNS exfiltration.

# Variables

| Name         | Type        | Description                                                   |
|--------------|-------------|---------------------------------------------------------------|
| name         | string      | Name for the project                                          |
| ns_subdomain | string      | Subdomain for the NS records                                  |
| subdomain    | string      | Subdomain for the A record                                    |
| zone_id      | string      | (Optional) Zone ID for Route53 records                        |
| volume_size  | string      | (Optional) Volume size for the EC2 Instance (default: 8GiB)   |
| volume_type  | string      | (Optional) Volume type (default: gp2)                         |
| common_tags  | map(string) | (Optional) Tags for the project                               |

# Example

module "jajdns_poc_exfil" {
  source       = "./modules/jajdns"
  name         = "JAJDNS"
  ns_subdomain = "jajtun1.jajexample.io"
  subdomain    = "jajt1.jajexample.io"
}

*/