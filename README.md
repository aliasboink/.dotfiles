# Dotfiles

## Arch Linux
wing it

## Linux Mint
For general use and change to i3 with lightdm-gtk-greeter:
```
sudo apt install xorg lightdm lightdm-gtk-greeter i3-wm i3lock i3status i3blocks rofi terminator dunst alacritty feh polybar stow neovim papirus-icon-theme
sudo systemctl enable lightdm.service
apt purge --autoremove slick-greeter lightdm-settings
```

For Starship follow [the instructions from the official repository](https://github.com/starship/starship).
