# Re-enable swaylock under authd via a dedicated pam_pwdfile stack

**Date:** 2026-07-07
**Status:** Design approved

## Problem

The machine logs in as an **authd-managed user** (a high-UID SSO account served
via NSS, with no local `/etc/passwd`/`/etc/shadow` password).
authd's PAM module (`pam_authd_exec.so`, pulled into `swaylock` today via
`/etc/pam.d/swaylock` → `include login` → `@include common-auth`) launches
authd's **interactive** client (`/usr/libexec/authd-pam`), which needs a rich
multi-step PAM conversation (broker menu, prompts, possibly device-code flow).

swaylock's PAM conversation only knows how to render a single password field, so
authd's client cannot drive it: swaylock **locks fine but never unlocks** — a
correct credential is rejected. GDM works only because it has the dedicated
`gdm-authd` stack plus a graphical authd extension. No Wayland locker implements
that, so swaylock cannot be made to speak authd.

The two workarounds the user found are dead ends:
`loginctl lock-session` only emits a D-Bus `Lock` signal that still routes back
to a swaylock-class locker (same problem); the ydotool "VT-bounce to GDM" trick
does not actually lock the session (you can VT-switch straight back) — insecure.

## Approach

Give swaylock its **own** `/etc/pam.d/swaylock` that ignores authd entirely and
authenticates against a self-managed `pam_pwdfile` secret. This is fully
isolated: `/etc/pam.d/swaylock` is read by swaylock and nothing else. GDM
(`gdm-authd`), TTY login (`login`), `sudo`, and the authd stack (`common-auth`,
`/etc/authd/`) are untouched, so **authd login and GDM keep working unchanged**.
Because we *remove* the `include login` line, swaylock also stops touching the
authd stack, so it cannot interfere with it either.

Rejected alternatives:
- **pam_unix + local shadow password** — fragile here: the user is NSS-served,
  not in `/etc/shadow`, and `passwd` routes back through authd. Not viable.
- **No locker, suspend only** — no real at-desk security; user explicitly wants
  a working lock.

## Changes

### 1. System (outside the repo — documented, not tracked)

- Install `libpam-pwdfile` (`sudo apt install -y libpam-pwdfile`).
- Create the secret file, owned by the user, mode `600`:
  `~/.config/swaylock/passwd` containing `paolo.gentili@canonical.com:<hash>`
  where `<hash>` is generated with e.g. `openssl passwd -6` (or `mkpasswd`).
- Replace `/etc/pam.d/swaylock` with:
  ```
  auth required pam_pwdfile.so pwdfile /home/paolo.gentili@canonical.com/.config/swaylock/passwd
  auth required pam_permit.so
  ```
  (pam_pwdfile needs an absolute path; `~` is not expanded by PAM.)

> **Caveat:** `/etc/pam.d/swaylock` is package-owned; a future `swaylock`
> package upgrade may prompt to overwrite it (dpkg conffile handling). The exact
> contents are recorded in the README so it is trivial to restore.

> **Note on the secret file:** `~/.config/swaylock/passwd` is a plaintext hash
> file and MUST NOT be tracked by git. It is a runtime secret, created by hand.
> The `.gitignore` already ignores `swaylock/config`; the `passwd` file lives in
> `~/.config/swaylock/` (the symlinked dir), so add an ignore rule / never
> `git add` it. It is not part of the repo checkout.

### 2. Repo — `sway/config`

- Re-enable locking in the existing swayidle block. Target behavior:
  - lock after ~10 min idle,
  - blank displays after lock,
  - lock before sleep (so any suspend — e.g. the waybar ⏻ button — returns to a
    locked screen).

  Replace the current idle block:
  ```
  exec swayidle -w \
      timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"'
  ```
  with a version that locks first, e.g.:
  ```
  exec swayidle -w \
      timeout 600 'swaylock -f' \
      timeout 900 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
      before-sleep 'swaylock -f'
  ```
  (swaylock reads `~/.config/swaylock/config`; `-f` daemonizes/forks — the
  existing config already sets `daemonize`, so confirm no double-fork issue and
  drop `-f` if redundant.)

- **Rebind `$mod+Escape` from suspend to lock** (currently line 95,
  `bindsym $mod+Escape exec systemctl suspend`):
  ```
  bindsym $mod+Escape exec swaylock -f
  ```
  Suspend remains reachable via the waybar ⏻ power button → Suspend, so no
  separate suspend keybind is added.

### 3. Repo — `README.md` "Screen locking" section (lines 113–122)

Rewrite from "there is no screen lock" to document the working setup:
- swaylock is active: `$mod+Escape` now **locks** (previously suspended);
  idle (~10 min) and `before-sleep` also lock; suspend moved to the waybar ⏻
  power button.
- Why authd forces a dedicated PAM stack (short version of the Problem above).
- The exact `/etc/pam.d/swaylock` contents, the `libpam-pwdfile` dependency, and
  the `~/.config/swaylock/passwd` creation step — since these live outside the
  repo and must be reproduced by hand on a new machine.
- Add `libpam-pwdfile` to the `apt install` dependency list.

## Testing / verification

Cannot be fully automated (needs a live session). Manual acceptance:
1. `pamtester swaylock "$USER" authenticate` (from `pamtester`, if available) —
   or simply lock and unlock — succeeds with the pwdfile passphrase and fails
   with a wrong one.
2. `$mod+Escape` locks; correct passphrase unlocks.
3. Idle ~10 min locks; suspend/resume returns to a locked screen.
4. **Regression:** log out and log back in via GDM with the normal authd
   credential — confirm authd login still works (proves isolation).

## Out of scope

Fingerprint unlock (`pam_fprintd`), auto day/night theme switching, and any
change to the authd or GDM configuration.
