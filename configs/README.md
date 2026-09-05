# Sanitized configurations

These files reproduce the validated lab without credentials, private keys,
licence data or appliance binaries.

- `provider/`: FRRouting integrated configurations for PE1, P1, P2 and PE2.
- `customer-edge/`: RouterOS commands for CE-A1, CE-A2, CE-B1 and CE-B2.
- `hosts/`: VPCS startup commands.

Linux VRF devices and MPLS sysctls are runtime state. Install the scripts under
[`../automation/scripts/`](../automation/scripts/) before relying on provider
configuration after a restart.
