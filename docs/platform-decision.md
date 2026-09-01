# Platform and software decision

Decision date: 2026-09-01

## Selected platform

Use the **stable GNS3 desktop release with its matching GNS3 VM on VMware
Workstation Pro**. Run four MikroTik CHR VMs as provider routers, four official
FRRouting containers as customer-edge routers, and four VPCS end hosts.

Why this combination:

- GNS3 recommends its VM for Windows and QEMU appliances.
- VMware is GNS3's preferred desktop hypervisor for performance and nested
  virtualization.
- MikroTik RouterOS v7 supports OSPF, MPLS/LDP, VRFs, and MP-BGP VPNv4.
- CHR's free licence is indefinite and retains the required features; its
  1 Mbps per-interface upload limit is adequate for this functional lab.
- Containerized FRR CEs conserve memory while retaining a real BGP control plane.
- VPCS is sufficient for ping/traceroute tests and costs almost no RAM.

## Target version baseline

| Component | Target | Status | Rule |
|---|---|---|---|
| GNS3 GUI/server | 2.2.59 stable | Not installed | GUI and VM versions must match |
| GNS3 VM | 2.2.59 | Not installed | Import only from the official GNS3 download |
| VMware Workstation Pro | Current supported stable build | Not installed | Record the exact build after installation |
| MikroTik CHR | RouterOS 7.21.5 long-term, x86-64 RAW image | Not downloaded | Official source only; do not commit the image |
| FRRouting CE | 10.7.0 official container | Not pulled | Record the immutable image digest after pull |
| VPCS | Version bundled with GNS3 2.2.59 | Not installed | Record `vpcs -v` if exposed |
| Wireshark/TShark | Current stable build | Not installed | Install Npcap and record exact version |
| Python | Current supported 3.x | Not installed | Pin packages later in a lock file |

RouterOS 7.21.5 is chosen from the long-term channel for a conservative,
repeatable lab baseline. Do not silently upgrade after configurations or
evidence exist; test a new version on a branch and update this table.

## Smallest accepted topology

| Role | Platform | Count | Reason it cannot be removed |
|---|---:|---:|---|
| PE | CHR | 2 | Required to terminate two-site L3VPNs and exchange VPNv4 routes |
| P | CHR | 2 | Creates two independent transit paths and keeps customer routes out of the core |
| CE | FRR | 4 | One CE per customer site for two customers with two sites each |
| Host | VPCS | 4 | Provides endpoint-level proof for both overlapping address spaces |

Total: 12 nodes, but only four are full QEMU router VMs.

## Licensing and image policy

- Download CHR only from MikroTik's official download page.
- Use the CHR free licence unless later throughput tests require a paid/trial tier.
- The free tier's 1 Mbps upload limit must be disclosed in QoS results.
- Never commit CHR disks, VMware/GNS3 VM media, licences, credentials, or keys.
- Do not download or redistribute unofficial Cisco images.

## Fallback

If VMware cannot coexist reliably with the active Windows virtualization
security stack, test the official GNS3 VM option supported by the installed
GNS3 release. Do not switch hypervisors mid-project without recording the exact
change because timing results may no longer be comparable.

## Official references

- [GNS3 Windows installation](https://docs.gns3.com/docs/getting-started/installation/windows)
- [GNS3 VM download and hypervisor guidance](https://docs.gns3.com/docs/getting-started/installation/download-gns3-vm)
- [GNS3 stable release guidance](https://docs.gns3.com/docs)
- [MikroTik CHR licensing](https://help.mikrotik.com/docs/spaces/ROS/pages/18350234/Cloud%20Hosted%20Router%20CHR)
- [MikroTik RouterOS downloads](https://mikrotik.com/download)
- [FRRouting releases](https://github.com/FRRouting/frr/releases)
