# Protocol design

## Layered control plane

| Layer | Technology | Function |
|---|---|---|
| Underlay | IS-IS level 2 | Advertises provider links and loopbacks |
| Transport | MPLS + LDP | Allocates and distributes labels for provider routes |
| VPN control plane | MP-BGP IPv4 VPN | Exchanges labelled customer routes between PE loopbacks |
| Tenant separation | Linux VRFs + route targets | Maintains independent customer routing tables |
| Access routing | PE-CE eBGP | Exchanges customer LAN prefixes at each site |

## IS-IS underlay

All provider routers are in area `49.0001` and operate as level-2-only nodes.
Provider links use point-to-point network type. Loopbacks are advertised as
stable `/32` identities for LDP and MP-BGP.

The five core links produce two equal-cost next hops from PE1 toward PE2's
loopback. Customer-facing links are excluded from IS-IS.

## MPLS and LDP

Each router uses its loopback as the LDP router ID and transport address. LDP
runs only on provider-facing interfaces. The Linux kernel must have MPLS input
enabled on those interfaces and a non-zero platform label space.

When forwarding VPN traffic, the outer label carries the packet to the remote
PE. The inner VPN label identifies the destination VRF at that PE.

## MP-BGP VPN routes

PE1 and PE2 establish an iBGP session in AS65000 using their loopbacks. The
IPv4 VPN address family carries customer prefixes, RDs, RT extended communities
and VPN labels.

- Customer A imports and exports RT `65000:100`.
- Customer B imports and exports RT `65000:200`.
- Unique per-PE RDs preserve distinct VPN NLRIs.

P1 and P2 do not participate in MP-BGP and do not need customer routes.

## PE-CE eBGP

Customer A uses AS65100 at both sites; Customer B uses AS65200 at both sites.
Each CE advertises only the exact LAN prefix present in its RouterOS
`BGP-NETWORKS` address list.

The PE applies `as-override` when advertising a remote-site route. Without it,
a CE would reject the remote route because its own customer AS already appears
in the AS path.

## Route selection and isolation

Customer routes are installed only in the matching PE VRF. Identical prefixes
can therefore have different next hops and labels without conflict. RT policy,
not the RD, decides which VRF imports a VPN route.
