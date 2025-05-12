#!/bin/sh

finish () {
    wg-quick down wg0
    exit 0
}
trap finish SIGTERM SIGINT SIGQUIT

wg-quick up "${WIREGUARD_CONFIG}"

# Infinite sleep
sleep infinity &

wait $!
