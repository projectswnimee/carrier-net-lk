# Automation scripts

Phase 7 will add read-only health checks here. Initial checks will validate
interface state, OSPF, LDP, MP-BGP, VRF route counts, and customer probes.

Do not hard-code credentials. Use environment variables and provide a redacted
`.env.example` only when the first script is implemented.
