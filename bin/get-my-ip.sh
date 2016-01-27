#!/bin/sh -eu

get_interface()
{
    route get 0.0.0.0 2>/dev/null | awk '/interface: /{print $2}'
}

get_ip()
{
    ifconfig -r $1 | awk '/inet /{print $2}'
}

# The _local_ IP of the current active network interface.
get_ip $(get_interface)
