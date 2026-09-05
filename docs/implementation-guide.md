# Implementation guide

This guide records the successful build order. Apply configuration files only
after verifying interface mappings against [`architecture.md`](architecture.md).

## 1. Platform

1. Install GNS3 2.2.61 and the matching GNS3 VM.
2. Allocate 2 vCPUs and 4096 MB RAM to the GNS3 VM.
3. Install the FRRDocker appliance and MikroTik CHR 7.22.1 template.
4. If `/dev/kvm` is unavailable, set the CHR QEMU option to
   `-nographic -machine accel=tcg`.
5. Verify one FRR and one CHR node before creating the complete topology.

## 2. Topology and addressing

Create 12 nodes and cable the 13 links in
[`architecture.md`](architecture.md). Apply provider `/31` and loopback `/32`
addresses first. Confirm every directly connected provider neighbour responds.

## 3. Provider underlay

Apply the four FRR configurations in [`../configs/provider/`](../configs/provider/).
Enable `isisd` and `ldpd`, set `net.mpls.platform_labels=100000`, and enable
MPLS input on provider interfaces. Verify IS-IS before troubleshooting LDP.

## 4. VPN service

Create Linux VRFs `CUST-A` and `CUST-B` on both PEs before starting FRR. Bind
`eth2` to CUST-A and `eth3` to CUST-B. Establish MP-BGP between PE loopbacks,
then configure each per-VRF PE-CE neighbour.

Apply the four RouterOS files under
[`../configs/customer-edge/`](../configs/customer-edge/). RouterOS 7.20 and
later requires an explicit `/routing bgp instance` referenced by each
connection.

## 5. Hosts and validation

Apply the VPCS commands from [`../configs/hosts/`](../configs/hosts/). Run the
checks in [`validation.md`](validation.md) from the bottom layer upward:

```text
interfaces -> IS-IS -> LDP/LFIB -> MP-BGP -> VRFs/eBGP -> end-to-end ping
```

## 6. Persistent recovery

FRRDocker's standard startup profile resets `isisd` and `ldpd`, while Linux
VRF devices and MPLS sysctls are runtime state. Install the role-appropriate
script and startup hook from [`../automation/scripts/`](../automation/scripts/).

Always back up `/usr/lib/frr/docker-start` before patching it. Re-test one node
at a time and allow protocol convergence before declaring recovery failed.
