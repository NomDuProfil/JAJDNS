locals {
  jajdns_output_content = <<EOF
Records Configuration:

Record Name: ${var.subdomain}
Type: A
Value: ${aws_instance.jajdns_ec2_instance.public_ip}
TTL: 300

Record Name: ${var.ns_subdomain}
Type: NS
Value: ${var.subdomain}.
TTL: 172800

Start DNS Tunnel: sudo iodine -f -P ${random_password.jajdns_generated_password.result} ${var.ns_subdomain}

Start SOCKS Proxy:

chmod 0600 jajdns_${var.name}_private_key.pem
ssh -ND 1212 -i jajdns_${var.name}_private_key.pem ec2-user@192.168.12.1
EOF
}

resource "local_file" "jajdns_output_file" {
  content  = local.jajdns_output_content
  filename = "jajdns_${var.name}_information.txt"
}