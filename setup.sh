#!/bin/sh
# Enable Touch ID for sudo on macOS Sonoma+.
set -e
T=/etc/pam.d/sudo_local.template
[ -f "$T" ] || { echo "Needs macOS Sonoma (14) or later." >&2; exit 1; }
sudo sh -c "sed 's/^#auth/auth/' $T > /etc/pam.d/sudo_local"
echo "Done. Open a new terminal tab and run: sudo -k; sudo true"
