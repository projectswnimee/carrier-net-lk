# Limitations

- CarrierNet-LK is a small educational lab, not a production carrier design.
- City codes are fictional labels and do not imply operator locations or architecture.
- Four provider routers prove path redundancy but not geographic or shared-risk diversity.
- Direct PE-to-PE MP-BGP does not scale like a route-reflector design.
- One RD per customer is intentionally simple; future multihoming may require unique per-PE RDs.
- Each CE uses a unique private AS, so version 1 does not demonstrate `as-override`.
- CHR's free licence limits upload to 1 Mbps per interface and can affect QoS measurements.
- Emulation timing depends on Windows load, the desktop hypervisor, and GNS3 VM scheduling.
- VPCS is useful for ICMP but a Linux host may be required for precise UDP/jitter tests.
- A Wireshark MPLS decode proves labelled forwarding in this lab, not performance or production readiness.
- Monitoring and automation are planned later; their presence must not be claimed before evidence exists.
