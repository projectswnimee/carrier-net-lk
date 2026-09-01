# Predecessor review

Reference project:
[projectswnimee/Sri-Lanka-Telco-Core](https://github.com/projectswnimee/Sri-Lanka-Telco-Core)

The predecessor was reviewed as a design/documentation reference; this
repository does not copy its Packet Tracer topology or present it as the same
technical work.

## Practices carried forward

- A clear addressing and device plan before configuration
- Reproducible, device-specific configuration exports
- A build guide and verification checklist
- Raw screenshot/command evidence tied to claims
- Honest documentation of emulator limitations and troubleshooting decisions
- Measured failover rather than unsupported availability claims

## Technical progression

| Predecessor | CarrierNet-LK progression |
|---|---|
| Packet Tracer multi-operator/campus simulation | GNS3 emulation with RouterOS and FRR |
| OSPF and eBGP IP forwarding | OSPF + LDP + MP-BGP VPNv4 + MPLS forwarding |
| Separate address domains | Deliberately overlapping customer prefixes inside VRFs |
| Core failover at IP layer | Label-switched core-path failure with protocol timelines |
| Screenshot-heavy evidence | Raw command output, PCAP, CSV measurements, and screenshots |

## Practices intentionally changed

- The new project uses fictional customer/operator identities throughout.
- It does not use Packet Tracer because the required MPLS L3VPN features need a
  more capable emulator.
- It does not copy or redistribute the predecessor's `.pkt` file or any router image.
- It starts with `not_run` test states and adds claims only after fresh evidence.
