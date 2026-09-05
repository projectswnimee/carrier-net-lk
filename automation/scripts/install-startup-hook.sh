#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: $0 core-init.sh|pe-init.sh" >&2
    exit 2
fi

source_script=$1
target_script=/etc/frr/carriernet-init.sh
docker_start=/usr/lib/frr/docker-start
backup=/usr/lib/frr/docker-start.carriernet-backup

test -f "$source_script"
install -o root -g frr -m 0750 "$source_script" "$target_script"

if [ ! -e "$backup" ]; then
    cp "$docker_start" "$backup"
fi

if ! grep -q 'carriernet-init.sh' "$docker_start"; then
    sed -i '/^apply_frr_profile$/a [ -x /etc/frr/carriernet-init.sh ] \&\& /etc/frr/carriernet-init.sh' "$docker_start"
fi

grep -n 'carriernet-init' "$docker_start"
"$target_script"
