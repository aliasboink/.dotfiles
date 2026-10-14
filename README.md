# Dotfiles

## Arch Linux
```
sudo pacman -S --needed xorg-server xorg-xrandr lightdm lightdm-gtk-greeter i3-wm i3lock xss-lock dex rofi dunst alacritty feh polybar flameshot brightnessctl polkit-gnome network-manager-applet libnotify libpulse psmisc stow neovim papirus-icon-theme npm base-devel
sudo systemctl enable lightdm.service
```

## Linux Mint
For general use and change to i3 with lightdm-gtk-greeter:
```
sudo apt install xorg lightdm lightdm-gtk-greeter i3-wm i3lock i3status i3blocks rofi terminator dunst alacritty feh polybar stow neovim papirus-icon-theme npm build-essential flameshot brightnessctl dex xss-lock policykit-1-gnome network-manager-gnome libnotify-bin pulseaudio-utils
sudo systemctl enable lightdm.service
apt purge --autoremove slick-greeter lightdm-settings
```

For Starship follow [the instructions from the official repository](https://github.com/starship/starship).
