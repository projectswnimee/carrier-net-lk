# Configuration exports

Configuration files are intentionally absent in Phase 1. Add them only after
the installed RouterOS/FRR versions are recorded and the preceding layer passes
its tests.

Naming convention: `<device>-phase-<number>-<layer>.rsc` for RouterOS exports
and `<device>-phase-<number>-<layer>.conf` for FRR. Exports must not include
credentials, private keys, binary backups, or licence data.
