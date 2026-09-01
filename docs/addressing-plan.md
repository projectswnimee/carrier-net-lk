# Addressing, AS, VRF, RD, and RT plan

## Addressing principles

- `10.255.0.0/24` is reserved for provider loopbacks; each router uses a `/32`.
- `10.0.0.0/24` is reserved for provider point-to-point links; `/31` conserves space.
- `172.16.100.0/24` and `172.16.200.0/24` are PE-CE transit pools for Customers A and B.
- The two customers deliberately reuse `10.10.10.0/24` and `10.10.20.0/24`.
- Infrastructure routes remain in `main`; customer routes remain inside their VRFs.

## Provider loopbacks

| Device | Address | OSPF router ID | LDP LSR/transport address | BGP router ID |
|---|---|---|---|---|
| PE-CMB | `10.255.0.1/32` | `10.255.0.1` | `10.255.0.1` | `10.255.0.1` |
| P-KDY | `10.255.0.2/32` | `10.255.0.2` | `10.255.0.2` | Not applicable |
| P-GLE | `10.255.0.3/32` | `10.255.0.3` | `10.255.0.3` | Not applicable |
| PE-JAF | `10.255.0.4/32` | `10.255.0.4` | `10.255.0.4` | `10.255.0.4` |

Loopbacks are passive in OSPF and advertised as host routes. They provide stable
identities even when one physical core path fails.

## Provider core links

| Link ID | Subnet | Endpoint A | Address A | Endpoint B | Address B | OSPF area | Initial cost |
|---|---|---|---|---|---|---|---:|
| CORE-01 | `10.0.0.0/31` | PE-CMB `ether1` | `10.0.0.0` | P-KDY `ether1` | `10.0.0.1` | 0 | 10 |
| CORE-02 | `10.0.0.2/31` | P-KDY `ether2` | `10.0.0.2` | PE-JAF `ether1` | `10.0.0.3` | 0 | 10 |
| CORE-03 | `10.0.0.4/31` | PE-CMB `ether2` | `10.0.0.4` | P-GLE `ether1` | `10.0.0.5` | 0 | 10 |
| CORE-04 | `10.0.0.6/31` | P-GLE `ether2` | `10.0.0.6` | PE-JAF `ether2` | `10.0.0.7` | 0 | 10 |

Equal costs permit the underlay to install equal-cost paths when RouterOS and
the emulated link state allow it. The project will measure actual forwarding
and convergence rather than infer it from the design.

## PE-CE transit links

| Link ID | VRF | Subnet | PE endpoint | PE address | CE endpoint | CE address |
|---|---|---|---|---|---|---|
| CUST-A-01 | `VRF-CUST-A` | `172.16.100.0/31` | PE-CMB `ether3` | `172.16.100.0` | CE-A1 `eth0` | `172.16.100.1` |
| CUST-A-02 | `VRF-CUST-A` | `172.16.100.2/31` | PE-JAF `ether3` | `172.16.100.2` | CE-A2 `eth0` | `172.16.100.3` |
| CUST-B-01 | `VRF-CUST-B` | `172.16.200.0/31` | PE-CMB `ether4` | `172.16.200.0` | CE-B1 `eth0` | `172.16.200.1` |
| CUST-B-02 | `VRF-CUST-B` | `172.16.200.2/31` | PE-JAF `ether4` | `172.16.200.2` | CE-B2 `eth0` | `172.16.200.3` |

Transit prefixes are unique for operational clarity. The customer LAN prefixes,
not the transport links, provide the required overlapping-address proof.

## Customer LANs

| Customer | Site | LAN prefix | CE gateway | Test host | Duplicate of |
|---|---|---|---|---|---|
| A | 1 | `10.10.10.0/24` | `10.10.10.1` | `10.10.10.10` | Customer B site 1 |
| A | 2 | `10.10.20.0/24` | `10.10.20.1` | `10.10.20.10` | Customer B site 2 |
| B | 1 | `10.10.10.0/24` | `10.10.10.1` | `10.10.10.10` | Customer A site 1 |
| B | 2 | `10.10.20.0/24` | `10.10.20.1` | `10.10.20.10` | Customer A site 2 |

The identical host addresses are intentional. Tests must identify both source
node and VRF because the IP address alone is ambiguous.

## Customer-unique isolation probes

| Customer | Device | Loopback prefix | Within-customer expectation | Other-customer expectation |
|---|---|---|---|---|
| A | CE-A2 | `192.0.2.100/32` | Reachable from Customer A site 1 | No route from Customer B |
| B | CE-B2 | `198.51.100.100/32` | Reachable from Customer B site 1 | No route from Customer A |

These RFC 5737 documentation addresses solve an important testing ambiguity:
because both customers use the same LAN host addresses, a ping to
`10.10.20.10` from either VRF naturally targets that customer's own site 2.
The unique `/32` probes permit a real cross-customer negative route/data-plane
test without weakening the overlapping-LAN demonstration.

## Autonomous systems

| Routing domain | AS number | Purpose |
|---|---:|---|
| CarrierNet-LK provider | 65000 | PE iBGP/MP-BGP and all PE-side eBGP sessions |
| Customer A site 1 | 65101 | CE-A1 eBGP |
| Customer A site 2 | 65102 | CE-A2 eBGP |
| Customer B site 1 | 65201 | CE-B1 eBGP |
| Customer B site 2 | 65202 | CE-B2 eBGP |

Each CE uses a different private AS. This avoids AS-path loop rejection between
sites without requiring `as-override` in the first release. A later controlled
extension can assign one AS per customer and document the required loop-handling policy.

## VRF and VPN identifiers

| Customer | VRF | RD | Import RT | Export RT | Imported prefixes |
|---|---|---|---|---|---|
| A | `VRF-CUST-A` | `65000:100` | `65000:100` | `65000:100` | Only Customer A routes |
| B | `VRF-CUST-B` | `65000:200` | `65000:200` | `65000:200` | Only Customer B routes |

The RD makes VPNv4 NLRIs distinct; the RT controls membership. The initial
single-service design uses one RD per customer on both PEs to match the project
requirement. If later multihoming creates identical customer prefixes from both
PEs, move to unique per-PE RDs while retaining the shared customer RT.

## Collision checks

- All four provider `/31` networks are disjoint.
- Provider loopbacks do not overlap core links or customer networks.
- PE-CE transit links do not overlap across customer VRFs.
- The only planned duplicates are the two customer LAN prefixes and host addresses.
- No customer prefix is advertised by OSPF or installed on a P router.
- `192.0.2.100/32` and `198.51.100.100/32` are documentation-only isolation probes.
