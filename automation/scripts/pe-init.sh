#!/bin/sh

# Runtime recovery for PE1 and PE2.
# Creates Linux VRFs before FRR starts, then restores MPLS runtime settings.

sed -i \
  -e 's/^isisd=no$/isisd=yes/' \
  -e 's/^ldpd=no$/ldpd=yes/' \
  /etc/frr/daemons

sysctl -w net.mpls.platform_labels=100000 >/dev/null

for iface in eth0 eth1; do
    if [ -e "/proc/sys/net/mpls/conf/${iface}/input" ]; then
        sysctl -w "net.mpls.conf.${iface}.input=1" >/dev/null
    fi
done

ip link show CUST-A >/dev/null 2>&1 ||
    ip link add CUST-A type vrf table 100
ip link set CUST-A up
ip link set eth2 master CUST-A

ip link show CUST-B >/dev/null 2>&1 ||
    ip link add CUST-B type vrf table 200
ip link set CUST-B up
ip link set eth3 master CUST-B

echo "CarrierNet PE recovery completed"
