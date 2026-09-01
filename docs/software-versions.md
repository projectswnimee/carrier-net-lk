# Software version lock

Do not fill observed values from memory or from a download page. Record them
from the installed software or appliance and attach the evidence file.

| Component | Planned version/channel | Observed version/build | Image digest or checksum | Evidence | State |
|---|---|---|---|---|---|
| GNS3 GUI/server | 2.2.59 stable | — | — | `ENV-011` | not installed |
| GNS3 VM | 2.2.59 | — | — | `ENV-012` | not installed |
| VMware Workstation Pro | current supported stable | — | — | `ENV-010` | not installed |
| MikroTik CHR | RouterOS 7.21.5 long-term | — | — | `ENV-020` | not downloaded |
| FRRouting container | 10.7.0 | — | — | `ENV-021` | not pulled |
| VPCS | bundled with GNS3 | — | — | `ENV-030` | not installed |
| Wireshark/TShark | current stable | — | — | `ENV-022` | not installed |
| Npcap | installer-compatible stable | — | — | `ENV-022` | not installed |
| Python | supported Python 3.x | — | — | `ENV-023` | not installed |

When an image is downloaded, verify the vendor-published checksum if available.
For a container, prefer the immutable repository digest. Never commit the image.
