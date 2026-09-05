# FRRDocker restart recovery

FRRDocker's `/usr/lib/frr/docker-start` applies the `standard` profile on every
start. That profile disables `isisd` and `ldpd`. Linux VRF devices and MPLS
sysctls are also runtime-only state.

Use `core-init.sh` on P1/P2 and `pe-init.sh` on PE1/PE2. Copy the repository
scripts into a node, then run as root:

```sh
./install-startup-hook.sh core-init.sh
```

or:

```sh
./install-startup-hook.sh pe-init.sh
```

The installer:

1. Copies the selected script to persistent `/etc/frr` storage.
2. Backs up the original `docker-start` file.
3. Adds an idempotent hook immediately after `apply_frr_profile`.
4. Executes the recovery once for immediate verification.

After a restart, wait for protocol convergence and verify:

```sh
grep -E '^(isisd|ldpd)=' /etc/frr/daemons
cat /proc/sys/net/mpls/platform_labels
vtysh -c 'show isis neighbor'
vtysh -c 'show mpls ldp neighbor'
```

On a PE, also verify:

```sh
ip -d link show type vrf
vtysh -c 'show bgp ipv4 vpn summary'
vtysh -c 'show bgp vrf CUST-A summary'
vtysh -c 'show bgp vrf CUST-B summary'
```

This hook is specific to the tested GNS3 FRRDocker image. Reapply and retest it
if the container is recreated or the appliance image is upgraded.
