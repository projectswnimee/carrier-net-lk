# Failure analysis template

Copy this section for each controlled experiment. Do not populate values until
the lab produces them.

## Experiment metadata

| Field | Value |
|---|---|
| Test ID | |
| Date/time and timezone | |
| Operator | |
| Software version lock commit | |
| Baseline health evidence | |
| Failure injected | |
| Exact command/action | |
| Probe source and destination | |
| Probe interval | |

## Hypothesis

State which protocol should react, the expected alternate path, and which
customer services should or should not be affected. Do not state an unmeasured
convergence target as a fact.

## Timeline

| Event | Timestamp | Relative time (ms) | Evidence |
|---|---|---:|---|
| Last successful pre-failure probe | | | |
| Failure applied | | | |
| OSPF state change | | | |
| LDP state/mapping change | | | |
| First failed probe | | | |
| First sustained recovered probe | | | |
| Baseline restored | | | |

## Measurements

| Metric | Value | Method |
|---|---:|---|
| Packets sent during observation window | | |
| Packets lost | | |
| Loss percentage | | |
| Estimated service interruption | | |
| OSPF convergence | | |
| LDP recovery | | |
| End-to-end service restoration | | |

## Interpretation

Separate observed facts from inference. Explain measurement resolution and
known sources of timing error, including the probe interval, host scheduling,
GNS3 VM load, and CHR free-licence rate limit.

## Reproduction

List the clean baseline commit, startup order, exact failure command, evidence
commands, and restoration command. Link every raw file; do not embed invented
console text in this document.
