# Evidence-based test plan

## Rules

- `pass` requires raw evidence at the recorded path.
- `fail` is a valid result and must not be erased.
- `not_run` means exactly that; it must never be summarized as successful.
- Record timestamps in ISO 8601 with a timezone.
- For convergence, record the probe interval and calculation method.
- Restore the baseline and verify health before each destructive test.

## Acceptance tests

| ID | Phase | Test | Explicit pass criterion | Primary evidence |
|---|---|---|---|---|
| ENV-001 | Environment | Hardware virtualization | Task Manager says Enabled | Screenshot |
| ENV-030 | Environment | 12-node capacity smoke test | All nodes stable and responsive for five idle minutes | Screenshot + CSV |
| UND-001 | Underlay | Core interface state | All eight core endpoints are running | Command output |
| UND-002 | Underlay | Direct neighbor reachability | Every core-link peer address replies | Command output |
| UND-003 | Underlay | OSPF adjacencies | Exactly four provider adjacencies, all Full at both ends | Command output |
| UND-004 | Underlay | Provider loopbacks | Every provider router reaches the other three `/32`s | Command output |
| UND-005 | Underlay | Redundant PE path | Alternate next hop exists or traffic recovers after one path removal | Route output + measurement |
| MPLS-001 | MPLS | LDP adjacencies | LDP session established over every core link | Command output |
| MPLS-002 | MPLS | Label mappings | Remote labels exist for remote provider loopbacks | Command output |
| MPLS-003 | MPLS | Customer-edge exclusion | No LDP neighbor or discovery on PE `ether3/ether4` | Command output |
| MPLS-004 | MPLS | Labelled core packet | Wireshark decodes MPLS on a P-facing link | PCAP + screenshot |
| VPN-001 | L3VPN | MP-BGP VPNv4 | PE session Established and expected VPNv4 NLRIs present | Command output |
| VPN-002 | L3VPN | PE-CE eBGP | Four sessions Established in the correct VRFs | Command output |
| VPN-003 | L3VPN | Customer A reachability | Host-A1 ↔ Host-A2 succeeds | Command output |
| VPN-004 | L3VPN | Customer B reachability | Host-B1 ↔ Host-B2 succeeds | Command output |
| ISO-001 | Isolation | Customer A to B denial | Host-A1 has no route to `198.51.100.100/32` and cannot reach it | Command output + route lookup |
| ISO-002 | Isolation | Customer B to A denial | Host-B1 has no route to `192.0.2.100/32` and cannot reach it | Command output + route lookup |
| ISO-003 | Isolation | Overlap proof | Both VRFs contain the same customer prefixes with different VPN context | PE route output |
| ISO-004 | Isolation | P-router hygiene | P-KDY and P-GLE contain no `10.10.10.0/24` or `10.10.20.0/24` route | Command output |
| RES-001 | Resilience | Upper-path failure | Service restores over lower path; packet loss/time measured | Continuous probe + protocol logs |
| RES-002 | Resilience | P-router shutdown | Service restores through surviving P router; loss/time measured | Continuous probe + protocol logs |
| RES-003 | Resilience | LDP-session loss | Impact and recovery are measured and explained | Logs + measurement |
| RES-004 | Resilience | MP-BGP-session loss | Existing/new route behavior is measured and explained | Logs + measurement |
| NEG-001 | Negative | Incorrect Customer A RT | Expected service failure occurs only in Customer A; correction restores it | Before/during/after evidence |
| QOS-001 | QoS | Congestion baseline | Bottleneck is demonstrated without QoS | Traffic-generator raw data |
| QOS-002 | QoS | Policy comparison | Priority class improvement is supported by latency/jitter/loss/throughput data | Raw data + analysis |

## Required positive and negative probes

Because both customers reuse the same host addresses, a command transcript must
identify the originating node. The two positive tests may target the same
destination IP but must be run separately from Host-A1 and Host-B1. Cross-VRF
isolation is primarily proved by control-plane separation and VRF-aware route
lookups; a bare ping to an overlapping IP is not sufficient because it naturally
resolves to the local customer's remote site.

The final address plan therefore includes customer-unique documentation
loopbacks `192.0.2.100/32` (A) and `198.51.100.100/32` (B). Verify each within
its own VPN, then verify the other VRF has no route. Do not mislabel the
overlapping destination ping as a cross-customer attempt.
