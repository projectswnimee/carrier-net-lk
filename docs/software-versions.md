# Software versions

Versions observed during the working lab build on 2026-09-02 through
2026-09-04:

| Component | Observed version/details |
|---|---|
| GNS3 GUI/server | 2.2.61 |
| GNS3 VM | 2.2.61 appliance |
| GNS3 VM kernel | `7.0.0-30-generic` |
| VMware Workstation | Workstation Pro 26H1 installation |
| FRRouting appliance | FRRouting 10.3 (`FRRDocker`) |
| MikroTik CHR | RouterOS 7.22.1 stable, x86_64 |
| VPCS | GNS3 bundled appliance |

The host hypervisor did not expose `/dev/kvm` inside the GNS3 VM. MikroTik CHR
was therefore configured to use QEMU software emulation (`accel=tcg`). This is
adequate for the small lab but slower than KVM acceleration.

The repository does not include the CHR disk image, GNS3 VM, VMware installer
or container layers.
