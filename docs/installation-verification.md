# Installation verification checklist

Current state: **not run**. Local discovery on 2026-09-01 did not find GNS3,
VMware/VirtualBox, Wireshark/TShark, Docker, or system Python on `PATH`.

## Pre-install gate

| ID | Check | Pass criterion | Evidence |
|---|---|---|---|
| ENV-001 | BIOS/UEFI virtualization | Task Manager reports `Virtualization: Enabled` | `evidence/screenshots/ENV-001-task-manager-virtualization.png` |
| ENV-002 | Free host memory | At least 4 GiB free before starting GNS3 | `evidence/command-outputs/ENV-002-host-memory.txt` |
| ENV-003 | Free disk | At least 35 GiB free on the installation drive | `evidence/command-outputs/ENV-003-disk-space.txt` |

PowerShell evidence commands (run in a normal user terminal):

```powershell
Get-CimInstance Win32_OperatingSystem |
  Select-Object @{n='FreeMemoryGiB';e={[math]::Round($_.FreePhysicalMemory/1MB,2)}}

Get-PSDrive C |
  Select-Object Name,@{n='FreeGiB';e={[math]::Round($_.Free/1GB,2)}}
```

## GNS3 and hypervisor

| ID | Check | Pass criterion | Evidence |
|---|---|---|---|
| ENV-010 | Hypervisor version | Exact VMware Workstation build recorded | `evidence/screenshots/ENV-010-vmware-about.png` |
| ENV-011 | GNS3 GUI version | Stable target installed; exact version recorded | `evidence/screenshots/ENV-011-gns3-about.png` |
| ENV-012 | GNS3 VM version | Matches GUI and status indicator is green | `evidence/screenshots/ENV-012-gns3-vm-green.png` |
| ENV-013 | VM resources | 4 vCPU and 6 GiB RAM assigned | `evidence/screenshots/ENV-013-gns3-vm-resources.png` |
| ENV-014 | Compute test | GNS3 server/VM test completes without error | `evidence/screenshots/ENV-014-gns3-compute-test.png` |

Use only official installers. If an installer offers Npcap, select the option
recommended by the current GNS3/Wireshark documentation. Reboot if requested.

## Appliance verification

### MikroTik CHR

Create one temporary CHR template from the official RouterOS 7.21.5 long-term
x86-64 RAW image, boot it, and capture:

```routeros
/system resource print
/system package print
/system license print
/interface print
```

| ID | Pass criterion | Evidence |
|---|---|---|
| ENV-020 | RouterOS reports 7.21.5, x86_64, intended CPU/RAM, and the expected free licence | `evidence/command-outputs/ENV-020-chr-version-license.txt` |

The image itself must remain outside the repository.

### FRRouting CE container

Pull the official FRRouting 10.7.0 image inside the GNS3 VM and record both the
reported version and immutable image digest:

```sh
vtysh -c 'show version'
docker image inspect quay.io/frrouting/frr:10.7.0 \
  --format '{{index .RepoDigests 0}}'
```

| ID | Pass criterion | Evidence |
|---|---|---|
| ENV-021 | FRR reports 10.7.0 and the digest is stored in `software-versions.md` | `evidence/command-outputs/ENV-021-frr-version-digest.txt` |

### Wireshark and Python

```powershell
tshark --version
py -3 --version
```

| ID | Pass criterion | Evidence |
|---|---|---|
| ENV-022 | TShark prints a version and can open a GNS3 capture | `evidence/command-outputs/ENV-022-tshark-version.txt` |
| ENV-023 | Python 3 prints a version | `evidence/command-outputs/ENV-023-python-version.txt` |

## Capacity smoke test

1. Start the GNS3 VM.
2. Add all four CHR, four FRR, and four VPCS nodes with the planned resources.
3. Start all nodes and wait five minutes at idle.
4. Capture Windows CPU/memory and GNS3 node states.
5. Open one console for each node type.

| ID | Pass criterion | Evidence |
|---|---|---|
| ENV-030 | All 12 nodes remain running, consoles respond, host stays usable, and no OOM event occurs | `evidence/screenshots/ENV-030-capacity-smoke-test.png` and `evidence/measurements/ENV-030-host-resources.csv` |

Only after `ENV-001` through `ENV-030` pass should Phase 2 configuration begin.
