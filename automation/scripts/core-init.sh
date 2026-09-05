#!/bin/sh

# Runtime recovery for P1 and P2.
# Install as /etc/frr/carriernet-init.sh and invoke it from docker-start after
# apply_frr_profile.

sed -i \
  -e 's/^isisd=no$/isisd=yes/' \
  -e 's/^ldpd=no$/ldpd=yes/' \
  /etc/frr/daemons

sysctl -w net.mpls.platform_labels=100000 >/dev/null

for iface in eth0 eth1 eth2; do
    if [ -e "/proc/sys/net/mpls/conf/${iface}/input" ]; then
        sysctl -w "net.mpls.conf.${iface}.input=1" >/dev/null
    fi
done

echo "CarrierNet core recovery completed"
