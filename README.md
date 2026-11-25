# Touch ID for sudo (macOS)

Use your fingerprint instead of typing your password whenever `sudo` asks for it.

## Requirements

- macOS Sonoma (14) or later
- A Mac with Touch ID, with a fingerprint already enrolled
- An admin account

## Setup

Run this in Terminal.app or iTerm — not inside an IDE-embedded or AI agent terminal, since sudo needs a real TTY to prompt for your password:

```sh
sudo sh -c 'sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template > /etc/pam.d/sudo_local'
```

Or clone this repo and run the script instead:

```sh
./setup.sh
```

## Verify

Open a **new** terminal tab, then run:

```sh
cat /etc/pam.d/sudo_local   # should show: auth sufficient pam_tid.so
sudo -k; sudo true          # should prompt for Touch ID
```

Your password still works as a fallback if Touch ID fails or isn't available.

## How it works

`sudo_local` is included by `/etc/pam.d/sudo` and, unlike that file, survives macOS updates — so don't edit `/etc/pam.d/sudo` directly. Touch ID is tried first; if it fails, sudo falls back to your password as normal.

## Troubleshooting

| Situation | What happens |
|:---|:---|
| tmux / screen | Touch ID doesn't work by default — see [tmux/screen support](#tmuxscreen-support) below |
| Lid closed / clamshell mode | Touch ID is unavailable; sudo falls back to your password |
| Older macOS (pre-Sonoma) | `sudo_local.template` doesn't exist; `setup.sh` exits with an error |

### tmux/screen support

Install `pam-reattach`:

```sh
brew install pam-reattach
```

Then add this line **above** `pam_tid.so` in `sudo_local`:

```
auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
```

Use `/usr/local/lib/pam/pam_reattach.so` instead on Intel Macs.

## Undo

```sh
sudo rm /etc/pam.d/sudo_local
```
