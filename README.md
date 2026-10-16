# Dotfiles

## Arch Linux
```
sudo pacman -S --needed xorg-server xorg-xrandr lightdm lightdm-gtk-greeter i3-wm i3lock xss-lock dex rofi dunst alacritty feh polybar flameshot brightnessctl polkit-gnome network-manager-applet libnotify libpulse psmisc stow neovim papirus-icon-theme npm base-devel
sudo systemctl enable lightdm.service
```

On an AMD graphics card, also install its Mesa drivers:
```
sudo pacman -S --needed mesa vulkan-radeon
```

## Sway
Same setup as i3, on Wayland. Both configs include `.config/wm/common.conf`, so a change to keys, workspaces or colours there applies to both. Waybar takes the place of polybar.

On top of the Arch packages above:
```
sudo pacman -S --needed sway swaybg swaylock swayidle waybar xdg-desktop-portal-wlr
```

Link the configs into `~` with stow:
```
cd ~/.dotfiles && stow .
```

Then pick "Sway" in lightdm's session menu.

## Sway only: PC (AMD CPU, AMD GPU)
A Sway-only install for the PC, with no i3, polybar or Xorg session. Every package here is something the sway, wm or waybar configs call.

Base system (pacstrap):
```
base linux linux-firmware amd-ucode networkmanager sudo openssh git neovim efibootmgr grub
```

AMD graphics drivers:
```
sudo pacman -S --needed mesa vulkan-radeon
```

Sway session:
```
sudo pacman -S --needed \
  sway swaybg swaylock swayidle waybar xdg-desktop-portal-wlr xorg-xwayland \
  alacritty rofi dunst libnotify flameshot grim wl-clipboard \
  dex polkit-gnome network-manager-applet \
  pipewire pipewire-pulse wireplumber libpulse \
  stow starship bash-completion papirus-icon-theme \
  noto-fonts noto-fonts-emoji ttf-nerd-fonts-symbols
```

- `grim` is what flameshot uses to take screenshots on Wayland.
- `libpulse` provides `pactl`, which the volume keys and `cycle_sink.sh` use.
- `xorg-xwayland` runs X11-only apps such as Steam and Discord.
- `ttf-nerd-fonts-symbols` holds the icons starship and waybar need. It replaces the full Nerd Fonts set, which runs to several GB.

There is no display manager. To start Sway on login to tty1, add this to `~/.bash_profile`:
```bash
[ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && exec sway
```

## Per-machine settings
The same configs run on every machine. Sway reads screen scale and other output settings for one machine from `.config/sway/hosts/<hostname>.conf`, named after `/etc/hostname`. Without that file sway uses its defaults, which suit a 1440p desktop. Give each machine its own hostname so they don't share a file.

In i3, text size comes from `Xft.dpi` in `~/.Xresources`, which stays out of this repo. Leave it unset for 96 DPI.

Polybar and waybar find the battery by themselves and leave it out on a desktop.

## Ubuntu
Ubuntu 24.04 or newer (older polybar has no tray). The login screen already lists i3 and Sway, so there's no display manager to change:
```
sudo apt install i3-wm i3lock xss-lock dex rofi dunst alacritty feh polybar flameshot brightnessctl policykit-1-gnome network-manager-gnome libnotify-bin pulseaudio-utils psmisc stow neovim papirus-icon-theme sway swaybg swaylock swayidle waybar xdg-desktop-portal-wlr
cd ~/.dotfiles && stow .
```

## Linux Mint
For general use and change to i3 with lightdm-gtk-greeter:
```
sudo apt install xorg lightdm lightdm-gtk-greeter i3-wm i3lock i3status i3blocks rofi terminator dunst alacritty feh polybar stow neovim papirus-icon-theme npm build-essential flameshot brightnessctl dex xss-lock policykit-1-gnome network-manager-gnome libnotify-bin pulseaudio-utils
sudo systemctl enable lightdm.service
apt purge --autoremove slick-greeter lightdm-settings
```

For Starship follow [the instructions from the official repository](https://github.com/starship/starship).
