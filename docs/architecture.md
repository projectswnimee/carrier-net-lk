# Logical architecture and interface map

## Provider core

The provider core is a four-router diamond. `PE-CMB` and `PE-JAF` are the only
routers that hold customer VRFs. `P-KDY` and `P-GLE` switch labels and learn
only provider infrastructure routes.

```text
                         P-KDY
                    ether1/  \ether2
                          /    \
             ether1  PE-CMB  PE-JAF  ether1
                          \    /
                    ether2\  /ether2
                         P-GLE
```

Customer attachment:

```text
Host-A1 -- CE-A1 -- PE-CMB                       PE-JAF -- CE-A2 -- Host-A2
Host-B1 -- CE-B1 -- PE-CMB                       PE-JAF -- CE-B2 -- Host-B2
```

The authoritative visual files are
[`../topology/logical-topology.drawio`](../topology/logical-topology.drawio),
[`../topology/logical-topology.svg`](../topology/logical-topology.svg), and
[`../topology/topology.png`](../topology/topology.png).

## Interface mapping

### Provider routers (MikroTik CHR)

| Device | Interface | Peer | Peer interface | Function | IP/VRF |
|---|---|---|---|---|---|
| PE-CMB | `loopback` | — | — | Router ID / MP-BGP / LDP transport | `10.255.0.1/32`, main |
| PE-CMB | `ether1` | P-KDY | `ether1` | Upper core path | `10.0.0.0/31`, main |
| PE-CMB | `ether2` | P-GLE | `ether1` | Lower core path | `10.0.0.4/31`, main |
| PE-CMB | `ether3` | CE-A1 | `eth0` | Customer A access | `172.16.100.0/31`, `VRF-CUST-A` |
| PE-CMB | `ether4` | CE-B1 | `eth0` | Customer B access | `172.16.200.0/31`, `VRF-CUST-B` |
| P-KDY | `loopback` | — | — | Router ID / LDP transport | `10.255.0.2/32`, main |
| P-KDY | `ether1` | PE-CMB | `ether1` | Upper-west core | `10.0.0.1/31`, main |
| P-KDY | `ether2` | PE-JAF | `ether1` | Upper-east core | `10.0.0.2/31`, main |
| P-GLE | `loopback` | — | — | Router ID / LDP transport | `10.255.0.3/32`, main |
| P-GLE | `ether1` | PE-CMB | `ether2` | Lower-west core | `10.0.0.5/31`, main |
| P-GLE | `ether2` | PE-JAF | `ether2` | Lower-east core | `10.0.0.6/31`, main |
| PE-JAF | `loopback` | — | — | Router ID / MP-BGP / LDP transport | `10.255.0.4/32`, main |
| PE-JAF | `ether1` | P-KDY | `ether2` | Upper core path | `10.0.0.3/31`, main |
| PE-JAF | `ether2` | P-GLE | `ether2` | Lower core path | `10.0.0.7/31`, main |
| PE-JAF | `ether3` | CE-A2 | `eth0` | Customer A access | `172.16.100.2/31`, `VRF-CUST-A` |
| PE-JAF | `ether4` | CE-B2 | `eth0` | Customer B access | `172.16.200.2/31`, `VRF-CUST-B` |

### Customer routers and hosts

| Device | Interface | Peer | Address | Routing domain |
|---|---|---|---|---|
| CE-A1 | `eth0` | PE-CMB `ether3` | `172.16.100.1/31` | AS65101 |
| CE-A1 | `eth1` | Host-A1 | `10.10.10.1/24` | Customer A site 1 |
| Host-A1 | `e0` | CE-A1 `eth1` | `10.10.10.10/24`, gateway `10.10.10.1` | Customer A |
| CE-A2 | `eth0` | PE-JAF `ether3` | `172.16.100.3/31` | AS65102 |
| CE-A2 | `eth1` | Host-A2 | `10.10.20.1/24` | Customer A site 2 |
| CE-A2 | `lo` | — | `192.0.2.100/32` | Customer A isolation probe |
| Host-A2 | `e0` | CE-A2 `eth1` | `10.10.20.10/24`, gateway `10.10.20.1` | Customer A |
| CE-B1 | `eth0` | PE-CMB `ether4` | `172.16.200.1/31` | AS65201 |
| CE-B1 | `eth1` | Host-B1 | `10.10.10.1/24` | Customer B site 1 |
| Host-B1 | `e0` | CE-B1 `eth1` | `10.10.10.10/24`, gateway `10.10.10.1` | Customer B |
| CE-B2 | `eth0` | PE-JAF `ether4` | `172.16.200.3/31` | AS65202 |
| CE-B2 | `eth1` | Host-B2 | `10.10.20.1/24` | Customer B site 2 |
| CE-B2 | `lo` | — | `198.51.100.100/32` | Customer B isolation probe |
| Host-B2 | `e0` | CE-B2 `eth1` | `10.10.20.10/24`, gateway `10.10.20.1` | Customer B |

## Interface invariants

- OSPF and LDP run only on `ether1` and `ether2` of provider routers.
- LDP never runs on PE customer-facing interfaces.
- `ether3` and `ether4` are assigned to their VRFs before their IP addresses are tested.
- P routers have no interfaces in a customer VRF and no PE-CE BGP sessions.
- PE MP-BGP peers use loopbacks, not physical-link addresses.
- All GNS3 link labels must include both peer names and subnet IDs.
- The two CE loopback probe addresses are documentation-only ranges and must
  never be advertised outside their own customer VRF.

## Failure domains

The upper and lower paths have equal OSPF cost in the initial design. Removing
either P router or either single core link must leave an alternate labelled path
between PE loopbacks. Failure tests change only one variable at a time and
restore the baseline before the next experiment.
