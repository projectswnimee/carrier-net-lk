# Project scope

## Purpose

CarrierNet-LK will build and validate a small fictional service-provider
backbone that transports two enterprise customers across shared MPLS
infrastructure. The central demonstration is that both customers can reuse the
same IPv4 LAN prefixes while retaining route and traffic isolation.

This is an educational lab. It does not represent, reproduce, or claim access
to the network design of Dialog, SLT-Mobitel, Hutch, or any other operator.
City codes are fictional labels used only to make the topology memorable.

## In scope

- Four-node redundant provider diamond with two PEs and two P routers
- OSPF area 0 underlay with stable `/32` loopbacks
- MPLS forwarding and LDP on provider-facing links
- Direct PE-to-PE MP-BGP VPNv4 in the first release
- Two VRFs, including overlapping customer prefixes
- eBGP on all four PE-CE adjacencies
- Repeatable positive reachability and negative isolation tests
- Core packet capture showing MPLS labels
- Controlled failure experiments with measured convergence
- Edge QoS experiment with latency, jitter, loss, and throughput measurements
- Basic monitoring and Python-based health verification
- Evidence-backed documentation and reproducible configuration exports

## Out of scope for the first release

- A real carrier or production design
- Unauthorized or redistributed network operating-system images
- Internet connectivity, NAT, subscriber access, mobile core, or voice core
- MPLS traffic engineering, segment routing, EVPN, or IPv6 VPN
- Route reflectors; the first release uses direct PE-to-PE MP-BGP
- Claims of carrier grade, high availability, or sub-second convergence without measurements

## Phase 1 deliverables

Phase 1 ends when the hardware decision, platform choice, topology, interface
map, addressing/AS/VRF plan, repository scaffold, and installation verification
record have been reviewed. It does **not** include MPLS configuration.

## Completion evidence

The project becomes portfolio-ready only when all required tests in
[`test-plan.md`](test-plan.md) are marked `pass` and link to reproducible raw
evidence. A diagram or configuration alone is not proof of operation.
