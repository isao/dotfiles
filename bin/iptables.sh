#!/bin/sh -ex
# https://www.digitalocean.com/community/articles/how-to-setup-a-basic-ip-tables-configuration-on-centos-6

######### SSHD PORT NUMBER HERE ##########
SSHD_PORT=
[[ -z $SSHD_PORT ]] && {
    echo "set SSHD_PORT before proceeeding. exiting."
    exit 1
}

# flush the firewall rules - erase them all
iptables -F

# blocking null packets (network scanning bots)
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# The next pattern to reject is a syn-flood attack.
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
# Syn-flood attack means that the attackers open a new connection, but do
# not state what they want (ie. SYN, ACK, whatever). They just want to
# take up our servers' resources. We won't accept such packages.

# Drop XMAS packets, also a recon packet.
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

## Open up ports for selected services

# localhost interface:
iptables -A INPUT -i lo -j ACCEPT
# We tell iptables to add (-A) a rule to the incoming (INPUT) filter table
# any trafic that comes to localhost interface (-i lo) and to accept (-j
# ACCEPT) it. Localhost is often used for, ie. your website or email
# server communicating with a database locally installed. That way our
# server can use the database, but the database is closed to exploits from
# the internet.


## allow web traffic
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# We added the two ports (http port 80, and https port 443) to the ACCEPT
# chain - allowing traffic in on those ports.

# To forward port 80 to 8080 for a webserver listening on 8080
#   iptables -A PREROUTING -t nat -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 8080


# Allow users use our SMTP servers:
#   iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
#   iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
# Like stated before, if we can influence our users, we should rather use
# the secure version, but often we can't dictate the terms and the clients
# will connect using port 25, which is much more easier to have passwords
# sniffed from.
#
# We now proceed to allow the users read email on their server:
#   iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
#   iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
# Those two rules will allow POP3 traffic. Again, we could increase
# security of our email server by just using the secure version of the
# service.
#
# Now we also need to allow IMAP mail protocol:
#   iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
#   iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

## Limiting SSH access

# Allow SSH traffic
iptables -A INPUT -p tcp -m tcp --dport $SSHD_PORT -j ACCEPT
# We now told iptables to add a rule for accepting tcp traffic incomming
# to port 22 (the default SSH port). It is advised to change the SSH
# configuration to a different port, and this firewall filter should be
# changed accordingly, but configuring SSH is not a part of this article.
# However, we could do one more thing about that with firewall itself. If
# our office has a permanent IP address, we could only allow connections
# to SSH from this source. This would allow only people from our location
# to connect. First, find out your outside IP address. Make sure it is not
# an address from your LAN, or it will not work. Type w in the terminal,
# we should see us logged in (if we're the only one logged in' and our IP
# address written down. The output looks something like this:
#   root@iptables# w
#   11:42:59 up 60 days, 11:21,  1 user,  load average: 0.00, 0.00, 0.00
#   USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
#   root   pts/0    213.191.xxx.xxx  09:27    0.00s  0.05s  0.00s w
#
# Now, you can create the firewall rule to only allow traffic to SSH port
# if it comes from one source: your IP address:
#   iptables -A INPUT -p tcp -s YOUR_IP_ADDRESS -m tcp --dport 22 -j ACCEPT
#
# We could open more ports on our firewall as needed by changing the port
# numbers. That way our firewall will allow access only to services we
# want.


## Allow outgoing connections
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# It will allow any established outgoing connections to receive replies
# from the server on the other side of that connection.
## block everything else
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP


## Save the configuration
#
# Now that we have all the configuration in, we can list the rules to see
# if anything is missing.
#
#   iptables -L -n
#
# The -n switch here is because we need only ip addresses, not domain
# names. Ie. if there is an IP in the rules like this: 69.55.48.33: the
# firewall would go look it up and see that it was a digitalocean.com IP.
# We don't need that, just the address itself. Now we can finally save our
# firewall configuration:
#
#   service iptables save
#
# The iptables configuration file on CentOS is located at
# /etc/sysconfig/iptables. The above command saved the rules we created
# into that file.
#
## Restart the firewall:
#
#   service iptables restart
#
# The saved rules will persist even when the server is rebooted.
