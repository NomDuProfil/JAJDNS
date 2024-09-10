resource "random_password" "jajdns_generated_password" {
  length           = 12
  special          = false
  upper            = true
  lower            = true
  numeric           = false
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}