# Automated test roadmap

The current release uses repeatable CLI checks documented in
[`../../docs/validation.md`](../../docs/validation.md). The next integration
phase will connect NetOps Automator 2.0 to GNS3 console endpoints and convert
the following checks into structured tests:

- expected IS-IS and LDP neighbour sets;
- MP-BGP and per-VRF eBGP session state;
- per-VRF route counts and RT membership;
- P-router customer-route absence;
- end-to-end probes and failure recovery;
- post-restart state restoration.

Credentials must be supplied through untracked environment variables. Test
code must never change routing state unless an explicit deployment mode and
rollback plan are selected.
