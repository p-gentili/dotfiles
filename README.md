# dotfiles

Personal config for a Sway (Wayland) desktop and terminal tooling.

## What's here

- **sway/** — window manager config (Catppuccin Latte theme)
- **waybar/** — status bar (workspaces, clock, system stats, tray, volume, backlight)
- **mako/** — notifications
- **wofi/** — application launcher (`$mod+d`)
- **swaylock/** — lock screen
- **kitty/**, **foot/** — terminals (follow the system light/dark preference)
- **nvim/**, **vim/**, **helix/** — editors
- **zsh/**, **.tmux.conf**, **zellij/**, **opencode/** — shell & tooling
- **.local/bin/** — helper scripts (`vol-notify`, `bright-notify`, `screenshot`)

## Dependencies

Install before running `link.sh`:

```bash
sudo apt install -y \
    sway waybar mako-notifier wofi \
    swaylock swayidle grim slurp brightnessctl playerctl \
    wl-clipboard
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
| `$mod+d` | App launcher (wofi) |
| `$mod+t` | File manager |
| `$mod+Shift+q` | Kill focused window |
| `$mod+Escape` | Lock screen |
| `$mod+h/j/k/l` | Move focus |
| `$mod+Shift+h/j/k/l` | Move window |
| `$mod+1..0` | Switch workspace |
| `$mod+Shift+1..0` | Move window to workspace |
| `$mod+f` | Fullscreen |
| `$mod+r` | Resize mode |
| `Print` | Screenshot (full → file + clipboard) |
| `Shift+Print` | Screenshot (region) |
| `$mod+Print` | Screenshot (focused window) |
| Brightness keys | Adjust backlight (with OSD) |
| Volume / mute / media keys | PipeWire volume + playerctl |

The screen auto-locks after 5 min idle and locks before sleep (swayidle).

## Deferred: automatic day/night theming

Currently the desktop uses **Catppuccin Latte (light)** only. The planned next
step is automatic switching to **Catppuccin Mocha** after sunset:

- Install [`darkman`](https://darkman.whynothugo.nl/) (static Go binary →
  `~/.local/bin`) and `geoclue-2.0`.
- darkman computes local sunrise/sunset and sets the freedesktop `color-scheme`
  preference — which **kitty and nvim already follow**.
- Add darkman light/dark hook scripts that re-point each app's theme to a
  Latte/Mocha variant and reload sway, waybar, mako, and wofi.
