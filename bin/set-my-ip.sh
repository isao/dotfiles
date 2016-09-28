#!/bin/bash -eu

# config
#
email=isao.yagi@gmail.com
token=$(security find-generic-password -ws 'Cloudflare API key' -a $email)
domain=pondr.in
subdomain=dev


# main
#
ip=$(get-my-ip)
record_id=199535263

## To get $record_id -- rec_load_all to get DNS Record ID
## https://www.cloudflare.com/docs/client-api.html#s3.3
# curl https://www.cloudflare.com/api_json.html \
#   -d a=rec_load_all \
#   -d tkn=$token \
#   -d email=$email \
#   -d z=$domain

oldip=$(host -4 -t A "$subdomain.$domain" | awk '{print $4}')

[[ $oldip = "$ip" ]] && {
    echo "* ip for '$subdomain.$domain' unchanged: $oldip"
    exit 0
}


# Set the ip for A record dev for target domain $domain
# https://www.cloudflare.com/docs/client-api.html#s5.2
echo "* Setting DNS A record for '$subdomain.$domain' to $ip"
curl -v https://www.cloudflare.com/api_json.html \
  -d a=rec_edit \
  -d tkn="$token" \
  -d email="$email" \
  -d id="$record_id" \
  -d z="$domain" \
  -d name="$subdomain" \
  -d type=A \
  -d content="$ip" \
  -d service_mode=1 \
  -d ttl=120

echo
