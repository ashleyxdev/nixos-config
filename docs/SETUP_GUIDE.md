# NixOS Hyprland Configuration Setup Guide

## Overview
This configuration sets up a complete Hyprland desktop environment with all essential tools.
It's designed to work both in VirtualBox (for testing) and on your HP Victus laptop.

## What's Included

### Desktop Environment
- **Hyprland**: Modern Wayland compositor with animations
- **Waybar**: Status bar with system information
- **Wofi**: Application launcher
- **Mako**: Notification daemon
- **Kitty**: GPU-accelerated terminal

### Applications
- **Firefox**: Web browser
- **Thunar**: File manager
- **Neovim**: Text editor
- **Zathura**: PDF viewer
- **Imv**: Image viewer

### System Tools
- **htop/btop**: System monitors
- **Git + GitHub CLI**: Version control
- **Network Manager**: Network management
- **PipeWire**: Audio system
- **polkit**: Privilege management

## Installation Steps

### 1. Backup Current Configuration
```bash
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
```

### 2. Replace Configuration
```bash
sudo cp configuration.nix /etc/nixos/configuration.nix
```

### 3. Rebuild System
```bash
sudo nixos-rebuild switch
```

This will download and install all packages. It may take 10-20 minutes on first run.

### 4. Reboot
```bash
sudo reboot
```

### 5. After Reboot - Install Dotfiles

Create necessary directories:
```bash
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/kitty
mkdir -p ~/.config/wofi
mkdir -p ~/.config/mako
mkdir -p ~/Pictures/Screenshots
```

Copy configuration files:
```bash
# Hyprland
cp hyprland.conf ~/.config/hypr/hyprland.conf

# Waybar
cp waybar-config.json ~/.config/waybar/config
cp waybar-style.css ~/.config/waybar/style.css

# Kitty
cp kitty.conf ~/.config/kitty/kitty.conf

# Wofi
cp wofi-config ~/.config/wofi/config
cp wofi-style.css ~/.config/wofi/style.css

# Mako
cp mako-config ~/.config/mako/config
```

### 6. Start Hyprland

From TTY (Ctrl+Alt+F2 if needed):
```bash
Hyprland
```

Or if you're already in a graphical session, log out and select Hyprland from your display manager.

## Essential Keybindings

### Window Management
- `Super + Return` - Open terminal (Kitty)
- `Super + Q` - Close window
- `Super + D` - Open application launcher (Wofi)
- `Super + E` - Open file manager (Thunar)
- `Super + V` - Toggle floating
- `Super + F` - Toggle fullscreen
- `Super + J` - Toggle split direction

### Navigation
- `Super + Arrow Keys` - Move focus between windows
- `Super + h/j/k/l` - Move focus (Vim keys)
- `Super + 1-9` - Switch to workspace 1-9
- `Super + Shift + 1-9` - Move window to workspace 1-9
- `Super + Mouse Drag` - Move window
- `Super + Right Click + Drag` - Resize window

### Screenshots
- `Print Screen` - Screenshot area to clipboard
- `Shift + Print Screen` - Screenshot area to file

### System
- `Super + Shift + E` - Exit Hyprland
- `Super + S` - Toggle scratchpad

### Media (on laptop)
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Mute toggle
- `XF86MonBrightnessUp` - Brightness up
- `XF86MonBrightnessDown` - Brightness down
- `XF86AudioPlay` - Play/Pause
- `XF86AudioNext` - Next track
- `XF86AudioPrev` - Previous track

## Testing in VirtualBox

1. Make sure VirtualBox Guest Additions are working:
   ```bash
   lsmod | grep vbox
   ```

2. Enable 3D acceleration in VirtualBox settings (for better performance)

3. Set video memory to at least 128MB in VirtualBox settings

## Preparing for Laptop Migration

### What Needs to Change

When you install NixOS on your laptop, you'll need to modify the configuration:

1. **Graphics Drivers** (NVIDIA RTX 2050):
   - Add NVIDIA drivers
   - Configure Optimus (Intel + NVIDIA)
   - Enable 144Hz display

2. **Disable VirtualBox Guest**:
   - Comment out or remove the `virtualisation.virtualbox.guest` section

3. **Power Management**:
   - Add TLP or auto-cpufreq for battery optimization
   - Enable laptop-mode

4. **Hardware-Specific**:
   - Touchpad configuration
   - Backlight control
   - Battery management

I'll create a separate configuration file for the laptop setup next.

### Files to Keep

These dotfiles will work identically on both VM and laptop:
- `~/.config/hypr/hyprland.conf`
- `~/.config/waybar/*`
- `~/.config/kitty/*`
- `~/.config/wofi/*`
- `~/.config/mako/*`

The only change needed in hyprland.conf is uncommenting the monitor line for 144Hz.

## Customization

### Change Wallpaper
```bash
swww img /path/to/your/wallpaper.jpg
```

### Edit Hyprland Config
```bash
nvim ~/.config/hypr/hyprland.conf
# Then reload: Super + Shift + C (if you add this keybind)
# Or restart Hyprland: Super + Shift + E
```

### Edit Waybar
```bash
nvim ~/.config/waybar/config
# Waybar auto-reloads on config change
```

### Change Terminal Colors
```bash
nvim ~/.config/kitty/kitty.conf
# Then: Ctrl+Shift+F5 to reload in kitty
```

## Troubleshooting

### Hyprland Won't Start
- Check logs: `journalctl -xe`
- Try from TTY: `Hyprland`
- Check if packages installed: `which Hyprland`

### No Sound
```bash
systemctl --user status pipewire
systemctl --user status pipewire-pulse
pavucontrol  # GUI to check audio settings
```

### Display Issues in VM
- Ensure 3D acceleration is enabled
- Increase video memory in VirtualBox settings
- Check: `echo $WAYLAND_DISPLAY`

### Network Issues
```bash
nmtui  # Terminal UI for NetworkManager
```

### Screenshots Not Working
```bash
# Check if tools are installed
which grim slurp wl-copy

# Create screenshots directory
mkdir -p ~/Pictures/Screenshots
```

## Next Steps

1. **Set up Zsh with Starship** (better prompt)
2. **Configure Neovim** (if you want a full IDE setup)
3. **Add more applications** to configuration.nix
4. **Test everything** in the VM thoroughly
5. **Prepare laptop-specific configuration** for migration

## Resources

- Hyprland Wiki: https://wiki.hyprland.org/
- NixOS Options: https://search.nixos.org/options
- NixOS Packages: https://search.nixos.org/packages

## Support

If something doesn't work:
1. Check the logs: `journalctl -xe`
2. Read error messages carefully
3. Search NixOS discourse: https://discourse.nixos.org/
4. Check Hyprland GitHub issues

Remember: NixOS is declarative - if something breaks, you can always roll back!
```bash
sudo nixos-rebuild switch --rollback
```
