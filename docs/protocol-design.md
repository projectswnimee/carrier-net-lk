# Protocol design

## Control and forwarding layers

| Layer | Protocol or mechanism | Scope | Purpose |
|---|---|---|---|
| Underlay | OSPFv2 area 0 | P and PE provider links | Reach all provider loopbacks through either core path |
| Transport | MPLS + LDP | Provider-facing interfaces only | Build label-switched paths to provider loopbacks |
| VPN control plane | MP-BGP VPNv4 | PE-CMB ↔ PE-JAF loopbacks | Exchange labelled customer VPN routes |
| Tenant isolation | VRFs + route targets | PEs only | Maintain independent routing tables for Customers A and B |
| Access routing | eBGP IPv4 unicast | Each PE-CE link, inside its VRF | Exchange site LAN and VPN routes |
| Data plane | Two-label MPLS stack where required | PE-to-PE across P routers | Carry tenant traffic over shared core links |

## OSPF underlay

- One OSPFv2 instance in area 0 on all provider routers.
- Router IDs are the provider loopback addresses.
- Loopbacks are passive; only four core links form adjacencies.
- Both PE-to-PE paths start with equal total cost.
- Customer interfaces are excluded from provider OSPF.

Phase gate: all expected OSPF adjacencies must be Full and every provider
loopback must remain reachable after either single core path is removed.

## MPLS and LDP

- Enable MPLS forwarding and LDP only on core interfaces.
- Use each provider loopback as the LSR ID and LDP transport address.
- Do not enable LDP on `ether3` or `ether4` of either PE.
- Verify local/remote mappings and forwarding entries before MP-BGP.

Stable loopback transport prevents an individual link failure from changing the
LDP session identity. LDP depends on the OSPF-resolved loopback path, so an
underlay defect must be fixed before troubleshooting labels.

## MP-BGP VPNv4

- Direct iBGP between `10.255.0.1` and `10.255.0.4` in AS65000.
- Activate the VPNv4 address family and exchange extended communities.
- Set the update source/local address to the PE loopback.
- Export each VRF's eligible BGP routes with its RD and RT.
- Resolve remote VPN next hops through the labelled provider underlay.

P routers do not run BGP and must never learn customer routes.

## VRFs and PE-CE eBGP

- `VRF-CUST-A`: interfaces `PE-CMB/ether3` and `PE-JAF/ether3`, RD/RT `65000:100`.
- `VRF-CUST-B`: interfaces `PE-CMB/ether4` and `PE-JAF/ether4`, RD/RT `65000:200`.
- CE site LANs are originated into their local eBGP session.
- Import policy admits only the matching customer RT.
- No route leaking exists between the two VRFs.

Using a unique private AS for each CE avoids needing AS override in version 1.
This is a deliberate simplification, not a hidden workaround.

## QoS (later phase)

Classification and marking occur at the customer-facing PE edge. Tests will
create voice-like UDP, business-critical traffic, and best-effort bulk traffic,
then introduce a measured bottleneck. QoS claims require before/after latency,
jitter, loss, and throughput data. The CHR free licence's 1 Mbps interface limit
is a lab constraint and must be included in the analysis.

## Monitoring (later phase)

Planned health checks cover interface state, OSPF neighbors, LDP sessions,
MP-BGP sessions, VRF route counts, CPU/memory, and end-to-end probes. Automation
must consume read-only credentials from untracked environment variables.

## Configuration freeze

No RouterOS or FRR configuration is authored in Phase 1. Before Phase 2, record
the installed versions and validate every command against the corresponding
official manual. Configuration exports must use deterministic filenames and
exclude credentials.
