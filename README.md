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
| waybar ☀/☾ button | Toggle light (Latte) / dark (Mocha) — or run `theme-toggle` |

The screen auto-locks after 5 min idle and locks before sleep (swayidle).

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
