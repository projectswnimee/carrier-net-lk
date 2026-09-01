# Hardware and virtualization assessment

Assessment date: 2026-09-01 (Asia/Colombo)

## Observed host facts

| Item | Observed value | Assessment |
|---|---|---|
| CPU | AMD Ryzen 7 7435HS | Suitable CPU family for a small GNS3 VM lab |
| Logical processors | 16 | Passes GNS3's recommended 4+ logical-core baseline |
| Physical RAM | 15.82 GiB | Meets the 16 GB class recommended for a small Windows GNS3 environment |
| Free RAM during assessment | 3.23 GiB | Below the 4 GB free-memory guidance; close heavy apps or reboot before lab work |
| Free space on `C:` | 95.7 GiB | Passes the 35 GB small-lab recommendation and 20 GB GNS3 VM minimum |
| Windows build | NT 10.0.26200.9168, 64-bit host assumed from AMD64 CPU | Record the displayed Windows edition during manual verification |
| Git | Present | Ready for repository work |
| GNS3 | Not found on `PATH` | Installation pending |
| VMware/VirtualBox CLI | Not found on `PATH` | Hypervisor installation pending |
| Wireshark/TShark | Not found on `PATH` | Installation pending |
| Docker | Not found on `PATH` | Not required on Windows when containers run inside the GNS3 VM |
| System Python | Not found on `PATH` | Installation pending for later automation work |

## Virtualization status

The processor model supports AMD hardware virtualization. Windows registry
signals show the virtualization stack and Hypervisor-Enforced Code Integrity
enabled, which is strong indirect evidence that a Windows hypervisor is active.
The sandbox could not query WMI or `systeminfo`, so BIOS/UEFI virtualization is
**not marked verified** yet.

Manual acceptance check:

1. Open **Task Manager → Performance → CPU**.
2. Confirm the line reads **Virtualization: Enabled**.
3. Save a screenshot as
   `evidence/screenshots/ENV-001-task-manager-virtualization.png`.
4. Record `pass` for `ENV-001` in `results/test-results.csv`.

## Resource recommendation

- GNS3 VM: start with **4 vCPU and 6 GiB RAM**.
- CHR PE nodes: **1 vCPU, 768 MiB RAM** each.
- CHR P nodes: **1 vCPU, 640 MiB RAM** each.
- FRR CE containers: **128–256 MiB RAM** each.
- VPCS: four nodes; memory impact is negligible compared with QEMU guests.

The CHR allocation is deliberately above MikroTik's RouterOS v7 sizing formula
for one vCPU and the planned interface counts. If Windows cannot retain at least
4 GiB free before starting GNS3, close browsers/IDEs or reboot; do not increase
the topology size.

## Decision

**Provisional pass** for the compact 12-node topology. Final acceptance depends
on the Task Manager virtualization check and a successful all-nodes-idle test in
the GNS3 VM. A 32 GB RAM upgrade would improve convenience, but it is not
required for the initial four-CHR/four-FRR design.

## Source notes

- Local facts were collected with read-only PowerShell/.NET and registry queries.
- GNS3's Windows guidance recommends 16 GB RAM, 4+ logical cores, SSD storage,
  and hardware virtualization for a small environment.
- The GNS3 VM documentation recommends at least 20 GB free disk and about 4 GB
  free memory, with the VM commonly using 2–4 GB before appliances are added.
