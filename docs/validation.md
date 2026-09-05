# Validation record

## Validated outcomes

| ID | Check | Result |
|---|---|---|
| ENV-001 | GNS3 GUI and VM connected | Pass |
| TOP-001 | 12 nodes and 13 intended links present | Pass |
| UND-001 | Direct provider-link reachability | Pass |
| UND-002 | Level-2 IS-IS adjacencies formed | Pass |
| UND-003 | PE loopbacks reachable over both next hops | Pass |
| MPLS-001 | LDP neighbours operational | Pass |
| MPLS-002 | LFIB contains provider and VPN labels | Pass |
| VPN-001 | PE1-PE2 MP-BGP IPv4 VPN established | Pass |
| VPN-002 | Four PE-CE eBGP sessions established | Pass |
| VPN-003 | Four VPN routes visible on each PE | Pass |
| VPN-004 | Customer A site-to-site ping | Pass |
| VPN-005 | Customer B site-to-site ping | Pass, operator observed |
| ISO-001 | Overlapping prefixes coexist in separate VRFs | Pass |
| RES-001 | Stop P1; traffic reconverges through P2 | Pass |
| RES-002 | Stop P2; traffic reconverges through P1 | Pass, operator observed |
| REC-001 | P-router automatic restart recovery | Pass |
| REC-002 | PE automatic MPLS/VRF/BGP recovery | Pass |

Raw outputs that were preserved are under
[`../evidence/command-outputs/`](../evidence/command-outputs/). A result marked
"operator observed" was confirmed interactively but has no raw transcript in
this repository.

## Core verification

Run on a PE:

```text
show isis neighbor
show ip route isis
show mpls ldp neighbor
show mpls ldp ipv4 binding
show mpls table
```

Expected: both P neighbours are up and operational; the remote PE loopback has
two underlay/MPLS next hops in the healthy state.

## VPN verification

```text
show bgp ipv4 vpn summary
show bgp ipv4 vpn
show bgp vrf CUST-A summary
show bgp vrf CUST-B summary
show ip route vrf CUST-A
show ip route vrf CUST-B
```

Expected: MP-BGP and PE-CE sessions have an uptime instead of an Idle/Active
state. The VPN table contains RDs `65000:101`, `65000:102`, `65000:201` and
`65000:202`.

## End-to-end tests

```text
PC-A1> ping 10.10.20.10
PC-A2> ping 10.10.10.10
PC-B1> ping 10.10.20.10
PC-B2> ping 10.10.10.10
```

The first packet can be lost while ARP resolves. Sustained replies demonstrate
the CE -> PE VRF -> MPLS -> remote PE VRF -> CE data path.

## Resilience method

Start a continuous site-to-site ping, stop one P router, and observe recovery.
Verify the failed P router disappears from IS-IS/LDP and that MP-BGP remains
established. Restore it and confirm the startup hook returns the node without
manual MPLS or daemon commands.

No millisecond convergence claim is made because probe timestamps were not
captured with measurement-grade tooling.
