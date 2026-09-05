# Addressing and VPN plan

## Provider loopbacks

| Router | Address | IS-IS system ID suffix | LDP/BGP identity |
|---|---|---|---|
| PE1 | `10.255.0.1/32` | `0001` | `10.255.0.1` |
| P1 | `10.255.0.2/32` | `0002` | `10.255.0.2` |
| P2 | `10.255.0.3/32` | `0003` | `10.255.0.3` |
| PE2 | `10.255.0.4/32` | `0004` | `10.255.0.4` |

## Provider point-to-point links

| Subnet | Endpoint A | Endpoint B |
|---|---|---|
| `10.0.0.0/31` | PE1 `eth0` = `10.0.0.0` | P1 `eth0` = `10.0.0.1` |
| `10.0.0.2/31` | P1 `eth1` = `10.0.0.2` | P2 `eth0` = `10.0.0.3` |
| `10.0.0.4/31` | P2 `eth1` = `10.0.0.4` | PE2 `eth0` = `10.0.0.5` |
| `10.0.0.6/31` | PE1 `eth1` = `10.0.0.6` | P2 `eth2` = `10.0.0.7` |
| `10.0.0.8/31` | P1 `eth2` = `10.0.0.8` | PE2 `eth1` = `10.0.0.9` |

## PE-CE links

| Customer | Site | VRF | PE address | CE address |
|---|---|---|---|---|
| A | 1 | `CUST-A` | PE1 `eth2` = `172.16.1.1/30` | CE-A1 `ether1` = `172.16.1.2/30` |
| A | 2 | `CUST-A` | PE2 `eth2` = `172.16.2.1/30` | CE-A2 `ether1` = `172.16.2.2/30` |
| B | 1 | `CUST-B` | PE1 `eth3` = `172.17.1.1/30` | CE-B1 `ether1` = `172.17.1.2/30` |
| B | 2 | `CUST-B` | PE2 `eth3` = `172.17.2.1/30` | CE-B2 `ether1` = `172.17.2.2/30` |

## Customer LANs

| Customer | Site | LAN | CE gateway | VPCS address |
|---|---|---|---|---|
| A | 1 | `10.10.10.0/24` | `10.10.10.1` | `10.10.10.10` |
| A | 2 | `10.10.20.0/24` | `10.10.20.1` | `10.10.20.10` |
| B | 1 | `10.10.10.0/24` | `10.10.10.1` | `10.10.10.10` |
| B | 2 | `10.10.20.0/24` | `10.10.20.1` | `10.10.20.10` |

The duplicate LANs and host addresses are intentional. `CUST-A` and `CUST-B`
are independent routing domains, so the same IPv4 prefixes can be used safely.

## AS, RD and RT assignments

| Domain | AS | PE1 RD | PE2 RD | Shared RT |
|---|---:|---|---|---|
| Provider | 65000 | - | - | - |
| Customer A | 65100 | `65000:101` | `65000:102` | `65000:100` |
| Customer B | 65200 | `65000:201` | `65000:202` | `65000:200` |

Unique RDs keep otherwise identical VPN NLRIs distinct. A shared RT joins the
two sites of one customer. Different RTs enforce the A/B VPN boundary.
