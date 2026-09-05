# RouterOS 7.22.1 - sanitized CLI commands
/system identity set name=CE-B1
/ip address add address=172.17.1.2/30 interface=ether1 comment=PE-WAN
/ip address add address=10.10.10.1/24 interface=ether2 comment=CUSTOMER-LAN
/ip firewall address-list add list=BGP-NETWORKS address=10.10.10.0/24
/routing bgp instance add name=AS65200 as=65200 router-id=172.17.1.2
/routing bgp connection add name=TO-PE1 instance=AS65200 remote.address=172.17.1.1 remote.as=65000 local.address=172.17.1.2 local.role=ebgp output.network=BGP-NETWORKS
