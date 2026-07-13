# dotfiles

Personal config for a Sway (Wayland) desktop and terminal tooling.

## What's here

- **sway/** — window manager config (Catppuccin Latte theme)
- **waybar/** — status bar (workspaces, clock, system stats, tray, volume, backlight, theme toggle, power menu)
- **mako/** — notifications
- **wofi/** — application launcher (`$mod+d`)
- **swaylock/** — lock screen (`$mod+Escape` / idle / before-sleep — see "Screen locking" below)
- **kitty/**, **foot/** — terminals (follow the system light/dark preference)
- **nvim/**, **vim/**, **helix/** — editors
- **zsh/**, **.tmux.conf**, **zellij/**, **opencode/** — shell & tooling
- **.local/bin/** — helper scripts (`vol-notify`, `bright-notify`, `screenshot`, `scratchterm`, `power-actions`, `wheel-workspace`)

## Dependencies

Install before running `link.sh`:

```bash
sudo apt install -y \
    sway waybar mako-notifier wofi \
    swaylock swayidle libpam-pwdfile grim slurp brightnessctl playerctl \
    wl-clipboard cliphist python3-evdev
```

`wl-clip-persist` isn't packaged for Ubuntu or published on crates.io; install
it from its GitHub repo (needs a Rust toolchain):

```bash
cargo install --git https://github.com/Linus789/wl-clip-persist.git
```

Waybar uses Nerd Font icon glyphs. Ubuntu's `fonts-font-awesome` is Font
Awesome 4 and does **not** provide them, so install a Nerd Font at user level
(no sudo):

```bash
mkdir -p ~/.local/share/fonts
curl -sSL -o /tmp/nf.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip -o /tmp/nf.zip -d /tmp/nf && cp /tmp/nf/*.ttf ~/.local/share/fonts/
fc-cache -f
```

## Install

```bash
./link.sh
```

This symlinks each config directory into `~/.config` and the scripts into
`~/.local/bin`. Re-run it any time after adding a new config.

## Keybindings (sway)

`$mod` = Super.

| Keys | Action |
|------|--------|
| `$mod+Return` | Terminal (kitty) |
| `$mod+Shift+Return` | Floating scratch terminal (see below) |
| `$mod+d` | App launcher (wofi) |
| `$mod+t` | File manager |
| `$mod+c` | Clipboard history picker (cliphist + wofi) |
| `$mod+Shift+q` | Kill focused window |
| `$mod+Escape` | Suspend |
| `$mod+h/j/k/l` | Move focus |
| `$mod+Shift+h/j/k/l` | Move window |
| `$mod+1..0` | Switch workspace |
| `$mod+Shift+1..0` | Move window to workspace |
| Three-finger swipe left/right | Switch workspace (touchpad, `bindgesture`) |
| MX Ergo horizontal wheel tilt | Switch workspace (mouse only, `wheel-workspace`) |
| `$mod+f` | Fullscreen |
| `$mod+r` | Resize mode |
| `Print` | Screenshot (full → file + clipboard) |
| `Shift+Print` | Screenshot (region) |
| `$mod+Print` | Screenshot (focused window) |
| Brightness keys | Adjust backlight (with OSD) |
| Volume / mute / media keys | PipeWire volume + playerctl |
| waybar ☀/☾ button | Toggle light (Latte) / dark (Mocha) — or run `theme-toggle` |
| waybar ⏻ button | Power menu: shutdown / reboot / suspend (`power-actions`) |

## Workspace switching by scroll (mouse vs touchpad)

Two independent mechanisms, deliberately split by device:

- **Touchpad** — a three-finger swipe (`bindgesture swipe:3` in `sway/config`).
- **MX Ergo trackball** — tilting the horizontal wheel, handled by the
  `wheel-workspace` script (`exec`'d from `sway/config`).

Why the script instead of one `bindsym button6/button7`? Sway bindings are
global and can't be scoped to a single device, so binding horizontal scroll
there also fired on the touchpad's two-finger drift. `wheel-workspace` reads
evdev directly and watches **only** the trackball (matched by name +
`REL_HWHEEL`), translating each tilt into `swaymsg workspace next/prev`. It
needs `python3-evdev` and read access to `/dev/input/event*` (i.e. membership
in the `input` group):

```bash
sudo apt install -y python3-evdev
sudo usermod -aG input "$USER"   # then log out / back in
```

## Floating windows & the scratch terminal

A few apps open floating and centered instead of tiled, via `for_window` rules
in `sway/config`: **Proton Authenticator**, the **Bitwarden** browser pop-out
(matched by its Firefox window title), and the **scratch terminal**.

**`$mod+Shift+Return`** launches a floating scratch terminal for quick commands
— a dark-tinted kitty (`#17251C`) that always opens centered. It runs through
`~/.local/bin/scratchterm`, which points `KITTY_CONFIG_DIRECTORY` at
`kitty/scratch/`. That dir deliberately has **no `*.auto.conf`** files, so
kitty's light/dark theme auto-switcher never runs for it and the fixed dark
background sticks — while the main terminals keep following the system
preference. The wrapper script exists because sway blanks `$HOME` when expanding
a `bindsym exec` line, so the config-dir path must be resolved by a real shell.

## Clipboard

`cliphist` records clipboard history (text and images) via two
`wl-paste --watch` recorders, and `wl-clip-persist` keeps the clipboard alive
after the source window closes (otherwise wlroots drops it). Press **`$mod+c`**
to fan the history through `wofi` and copy the chosen entry back. Wipe history
with `cliphist wipe`.

## Screen locking

swaylock locks the screen: **`$mod+Escape`** locks manually, swayidle locks
after 10 min idle (then blanks the displays), and any suspend locks on resume
(`before-sleep`). Suspend now lives on the waybar **⏻ button → Suspend**.

Why it needs a dedicated PAM stack: this box logs in as an
[authd](https://github.com/canonical/authd)-managed user (Google/Canonical SSO).
authd authenticates through an **interactive** PAM client (broker menus, device
codes) that only a rich greeter like GDM can drive — swaylock's single password
field can't, so with the default PAM config swaylock locks but never unlocks. So
swaylock is given its own auth path that ignores authd and checks a self-managed
password via `pam_pwdfile`. This is fully isolated — GDM, TTY login and the
authd stack are untouched.

Setup (all outside this repo, do once per machine):

```bash
sudo apt install -y libpam-pwdfile

PWFILE="$HOME/.config/swaylock/passwd"

# create the unlock-password hash (prompts twice, no echo)
mkdir -p "$(dirname "$PWFILE")"
umask 077
printf '%s:%s\n' "$USER" "$(mkpasswd -m sha-512)" > "$PWFILE"
chmod 600 "$PWFILE"

# point swaylock's PAM at it (PAM does not expand ~/$HOME — the absolute path
# is baked in here at write time by the unquoted heredoc)
sudo tee /etc/pam.d/swaylock >/dev/null <<EOF
auth required pam_pwdfile.so pwdfile $PWFILE
auth required pam_permit.so
EOF
```

`$PWFILE` (`~/.config/swaylock/passwd`) is a plaintext hash and a runtime
secret — never commit it. `/etc/pam.d/swaylock` is package-owned, so a
`swaylock` upgrade may prompt to overwrite it; re-run the `tee` block above to
restore it. Change the password later by re-running the `mkpasswd` line.

## Theme switching (Latte ⇄ Mocha)

The desktop ships **Catppuccin Latte** (light) as the default and can flip to
**Catppuccin Mocha** (dark) on demand. Click the **☀/☾ button** in waybar, or
run `theme-toggle`. To force a mode: `theme-apply light` / `theme-apply dark`.

How it works: the freedesktop `color-scheme` preference is the source of truth —
**kitty and nvim follow it automatically**. `theme-apply` also repoints a
gitignored per-app pointer symlink (`colors.css`, `theme.conf`, `style.css`,
`config`) to the Latte or Mocha variant and reloads waybar, sway, and mako.
`link.sh` seeds those pointers to Latte on a fresh checkout; git never tracks
which mode is active, so `git status` stays clean either way.

### Deferred: automatic day/night switching

To later switch on sunset instead of by click, install
[`darkman`](https://darkman.whynothugo.nl/) + `geoclue-2.0` and have it call
`theme-apply dark` from `~/.local/share/dark-mode.d/` and `theme-apply light`
from `~/.local/share/light-mode.d/`. No other change is needed — the manual
toggle keeps working as an override.
