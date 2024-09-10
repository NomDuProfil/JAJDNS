# JAJDNS

# Description

This project aims to quickly deploy an EC2 instance in AWS via Terraform to create a tunnel over DNS. Additionally, it will be possible to set up a SOCKS proxy.

This project is based on the following utility: `https://github.com/yarrick/iodine`.

The created EC2 instance will be accessible via SSM, and only port 53 will be open for inbound UDP traffic. All outbound traffic is allowed.

# Declaration and deployment

In the `jajdns.tf` file, add a statement like this one:

```terraform
module "jajdns_poc_exfil" {
  source       = "./modules/jajdns"
  name         = "JAJDNS"
  ns_subdomain = "jajtun1.jajexample.io"
  subdomain    = "jajt1.jajexample.io"
  zone_id      = "Z1D633PJN98FT9"
}
```

Some explanations for these variables:

- `name`: It's just a name for your EC2 Instance and other AWS object.
- `ns_subdomain`: The NS records that will be used to reach our tunnel.
- `subdomain`: The A records that will be used for our EC2 instance.
- `zone_id`: It's optional, but you can provide your Route53 Zone ID, and Terraform will create the record for you (Ex. Z1D633PJN98FT9).

Once configured, you can run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

# Usage

Once deployed, two files will be created:

- jajdns_NAME_private_key.pem: The SSH key for the EC2 instance. It will be used for the SOCKS proxy. 
- jajdns_NAME_information.txt: All the information you need to use your tunnel.

Here is an example of the `jajdns_NAME_information.txt` file:

```txt
Records Configuration:

Record Name: jajt1.jajexample.io
Type: A
Value: 12.12.12.12
TTL: 300

Record Name: jajtun1.jajexample.io
Type: NS
Value: jajt1.jajexample.io.
TTL: 172800

Start DNS Tunnel:

sudo iodine -f -P PiIJ3lkTESiS jajtun1.jajexample.io

Start SOCKS Proxy:

chmod 0600 jajdns_NAME_private_key.pem
ssh -ND 1212 -i jajdns_NAME_private_key.pem ec2-user@192.168.12.1

Test SOCKS Proxy:

curl -x socks5h://127.0.0.1:1212 http://ifconfig.me/ip
```

This file will give you all the commands to start and use your tunnel. Once the SOCKS proxy is ready, you can configure it in your browser.

Enjoy!