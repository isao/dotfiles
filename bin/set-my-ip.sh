#!/bin/bash -eu

# config
#

cfapi=https://api.cloudflare.com/client/v4
email=isao.yagi@gmail.com
token=$(security find-generic-password -w -s 'Cloudflare API key' -a $email)
domain=dev.pondr.in

zone_id=9d21fc88791813915873f835a76e8caa
# See https://api.cloudflare.com/#zone-list-zones

record_id=57ac792dcc559d2a934ca7d02d6b028d
# See https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records


# checks
#

ip=$(get-my-ip)
oldip=$(host -4 -t A $domain | awk '{print $4}')

[[ $oldip = "$ip" ]] && {
    echo "* ip for $domain unchanged: $oldip"
    exit 0
}

# main
#

echo "* Setting DNS A record for $domain to $ip"
curl -X PUT "$cfapi/zones/$zone_id/dns_records/$record_id" \
    -H "X-Auth-Email: $email" \
    -H "X-Auth-Key: $token" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'$domain'","content":"'$ip'","ttl":120}'
# See https://api.cloudflare.com/#dns-records-for-a-zone-update-dns-record
