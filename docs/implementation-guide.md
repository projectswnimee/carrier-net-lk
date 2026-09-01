# Implementation guide

This guide defines the safe build sequence. Commands will be added only after
the exact RouterOS and FRR versions have been installed and verified.

## Stage 0 — install and record the platform

Complete every `ENV-*` test in [`installation-verification.md`](installation-verification.md).
The GNS3 GUI and VM versions must match, hardware virtualization must be
enabled, and all planned nodes must remain running at idle without exhausting
host memory.

Gate: installation tests pass and exact versions/digests are committed.

## Stage 1 — create and cable the topology

1. Create a new GNS3 project named `CarrierNet-LK`.
2. Add four CHR nodes, four FRR CEs, and four VPCS hosts.
3. Rename every node before cabling.
4. Set CHR adapter counts: PEs = 4, P routers = 2.
5. Give each CE two interfaces.
6. Cable exactly as specified in [`architecture.md`](architecture.md).
7. Add subnet labels to every link and export a topology screenshot.

Gate: a second pass confirms every endpoint and interface against the mapping.

## Stage 2 — interface and IP underlay

1. Remove or disable any default CHR configuration that could introduce DHCP,
   NAT, bridging, or `192.168.88.0/24` into the lab.
2. Create provider loopbacks and set identity names.
3. Apply the four core `/31` subnets.
4. Verify interface state and directly connected pings.
5. Configure OSPF area 0 and explicit router IDs.
6. Make loopbacks passive; form adjacencies only on core links.
7. Verify all loopbacks and both PE-to-PE routes.
8. Remove one core link, measure the loss, and prove recovery; then restore it.

Gate: all `UND-*` tests pass. Do not configure MPLS earlier.

## Stage 3 — MPLS transport

1. Configure LDP with loopback LSR IDs and transport addresses.
2. Enable LDP on `ether1` and `ether2` provider links only.
3. Verify neighbor state, local/remote labels, and forwarding entries.
4. Capture PE-loopback traffic on one P-facing link and identify the MPLS label.

Gate: all `MPLS-*` tests pass and no customer-facing link emits LDP.

## Stage 4 — L3VPN service

1. Establish PE-to-PE MP-BGP VPNv4 using loopbacks.
2. Create `VRF-CUST-A` and `VRF-CUST-B` on both PEs.
3. Assign PE customer-facing interfaces to the correct VRF.
4. Apply PE-CE `/31` addresses and configure eBGP per the AS plan.
5. Configure CE LANs and VPCS addresses.
6. Export/import VPN routes using the planned RD/RT values.
7. Verify BGP, VPNv4, VRF tables, labels, and host reachability.
8. Run negative cross-customer tests and inspect P-router routing tables.

Gate: all `VPN-*` and `ISO-*` tests pass.

## Stage 5 — failure and QoS experiments

Run one controlled failure at a time using the template in
[`failure-analysis.md`](failure-analysis.md). Restore and verify baseline state
between runs. QoS experiments require a repeatable traffic generator and raw
before/after files; do not interpret an uncongested test as evidence of QoS.

## Stage 6 — automation and monitoring

Create read-only health checks, machine-readable inventory, and unit/integration
tests. Credentials belong in untracked environment variables. Monitoring output
is timestamped and written to `evidence/measurements/`.

## Export discipline

- Save human-readable configuration exports after each passed phase.
- Prefix raw command output with test ID, device, and UTC timestamp.
- Do not replace failed evidence; add a new attempt and explain the correction.
- Keep software images and binary RouterOS backups outside Git.
