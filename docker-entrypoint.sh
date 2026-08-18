#!/bin/sh
set -eu

host_key=/etc/ssh/host-keys/ssh_host_ed25519_key

install -d -m 0755 /run/sshd

if [ ! -f "$host_key" ]; then
    ssh-keygen -q -t ed25519 -N '' -f "$host_key"
fi

exec "$@"
