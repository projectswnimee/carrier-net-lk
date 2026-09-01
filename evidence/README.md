# Evidence policy

Evidence files are outputs produced by the lab, not hand-written examples.

- `command-outputs/`: raw text exported from device or host commands
- `packet-captures/`: original `.pcap`/`.pcapng` files
- `screenshots/`: UI or decoded-packet screenshots
- `measurements/`: machine-readable timing, resource, and QoS datasets

Filename format:

```text
<TEST-ID>-<device-or-scope>-<description>.<extension>
```

Never overwrite evidence from a failed attempt. Add `-attempt-02` and explain
the change in the result notes. Redact secrets before committing; if redaction
would undermine the evidence, do not publish that file.
