# Limitations and future work

- This is a small educational lab, not a production carrier reference design.
- P-router redundancy is demonstrated, but each customer site is single-homed
  to one PE and therefore has no PE or access-circuit redundancy.
- Direct PE-to-PE MP-BGP does not scale like a route-reflector architecture.
- Route-target separation and overlapping prefixes were verified; explicit
  unique-prefix cross-customer negative probes remain future work.
- No packet capture is committed, so the MPLS stack is evidenced by the LFIB
  and recursive labelled routes rather than Wireshark decoding.
- Failover was observed interactively, not measured with high-resolution timing.
- QoS, traffic engineering, BFD and Segment Routing are outside this release.
- CHR uses QEMU TCG because KVM was unavailable, reducing performance.
- The startup hook patches an appliance file and should be revalidated after an
  FRRDocker image update or node recreation.
- Router and appliance configuration changes are not yet deployed by a central
  automation controller; that integration belongs to NetOps Automator 2.0.

Useful extensions include route reflectors, dual-homed CEs, BFD-assisted
failure detection, automated validation through the GNS3 API, packet-capture
tests and timestamped convergence measurements.
