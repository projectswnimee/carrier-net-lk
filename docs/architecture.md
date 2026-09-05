# Architecture

## Roles

| Node | Platform | Role |
|---|---|---|
| PE1, PE2 | FRRDocker / FRRouting 10.3 | Provider edge, VRFs, PE-CE eBGP and MP-BGP VPN |
| P1, P2 | FRRDocker / FRRouting 10.3 | Label-switching provider core |
| CE-A1, CE-A2 | MikroTik CHR 7.22.1 | Customer A edge, AS65100 |
| CE-B1, CE-B2 | MikroTik CHR 7.22.1 | Customer B edge, AS65200 |
| PC-A1, PC-A2, PC-B1, PC-B2 | VPCS | Customer endpoints |

Only PE1 and PE2 contain customer VRFs. P1 and P2 provide transit and switch
MPLS labels without learning customer LAN routes.

## Authoritative link map

| Link | Endpoint A | Endpoint B | Purpose |
|---|---|---|---|
| 1 | PE1 `eth0` | P1 `eth0` | Provider core |
| 2 | P1 `eth1` | P2 `eth0` | Provider core |
| 3 | P2 `eth1` | PE2 `eth0` | Provider core |
| 4 | PE1 `eth1` | P2 `eth2` | Alternate provider path |
| 5 | P1 `eth2` | PE2 `eth1` | Alternate provider path |
| 6 | PE1 `eth2` | CE-A1 `ether1` | Customer A site 1 |
| 7 | PE1 `eth3` | CE-B1 `ether1` | Customer B site 1 |
| 8 | PE2 `eth2` | CE-A2 `ether1` | Customer A site 2 |
| 9 | PE2 `eth3` | CE-B2 `ether1` | Customer B site 2 |
| 10 | CE-A1 `ether2` | PC-A1 `Ethernet0` | Customer A LAN 1 |
| 11 | CE-A2 `ether2` | PC-A2 `Ethernet0` | Customer A LAN 2 |
| 12 | CE-B1 `ether2` | PC-B1 `Ethernet0` | Customer B LAN 1 |
| 13 | CE-B2 `ether2` | PC-B2 `Ethernet0` | Customer B LAN 2 |

## Failure domains

From PE1 to PE2, traffic can use either of these principal paths:

```text
PE1 -> P1 -> PE2
PE1 -> P2 -> PE2
```

The P1-P2 link also keeps the provider core connected during several individual
link failures. Stopping either P router was tested; IS-IS and LDP reconverged
and the customer ping recovered over the surviving path.

PE redundancy is outside the current scope. Stopping PE1 disconnects both
site-1 access links, and stopping PE2 disconnects both site-2 access links.
