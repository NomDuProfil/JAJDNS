variable "name" {
    type        = string
    default     = "JAJDNS"
    description = "Name for the project"
}

variable "ns_subdomain" {
  type        = string
  description = "Subdomain for the NS records"
}

variable "subdomain" {
  type        = string
  description = "Subdomain for the A record"
}

variable "zone_id" {
    type        = string
    default     = ""
    description = "(Optional) Zone ID for Route53 records"  
}

variable "volume_size" {
  type        = number
  default     = 8
  description = "Volume size for the EC2 Instance (default: 8GiB)"
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "Volume type (default: gp2)"
}

variable "common_tags" {
    type        = map(string)
    default     = {Project: "JAJDNS"}
    description = "Tags for the project"
}