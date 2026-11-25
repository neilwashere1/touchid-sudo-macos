# Touch ID for sudo (macOS)

Use your fingerprint instead of typing your password whenever `sudo` asks for it.

**Requires:** macOS Sonoma (14) or later, a Mac with Touch ID, a fingerprint already enrolled, and an admin account.

## Quick setup

Run this in Terminal.app or iTerm (not inside an IDE-embedded or AI agent terminal, because sudo needs a real TTY for your password):

```sh
sudo sh -c 'sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template > /etc/pam.d/sudo_local'
```

Or run the script: `./setup.sh`

## Verify

Open a **new** terminal tab:

```sh
cat /etc/pam.d/sudo_local   # should show: auth sufficient pam_tid.so
sudo -k; sudo true          # should show the Touch ID prompt
```

Your password still works as a fallback.

## Notes

- `sudo_local` survives macOS updates. Don't edit `/etc/pam.d/sudo` directly, because updates overwrite it.
- **tmux/screen:** Touch ID won't work unless you install `pam-reattach` (`brew install pam-reattach`) and add this line **above** `pam_tid.so` in `sudo_local`:
  `auth       optional       /opt/homebrew/lib/pam/pam_reattach.so`
  (use `/usr/local/lib/pam/pam_reattach.so` on Intel Macs)
- Lid closed / clamshell mode: Touch ID is unavailable, so it falls back to the password.

## Undo

```sh
sudo rm /etc/pam.d/sudo_local
```
