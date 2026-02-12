# NixOS Hyprland Quick Reference Card

## Essential Hyprland Keybindings

### Launch Applications
| Key                 | Action                    |
|---------------------|---------------------------|
| Super + Return      | Open terminal (Kitty)     |
| Super + D           | App launcher (Wofi)       |
| Super + E           | File manager (Thunar)     |

### Window Management
| Key                 | Action                    |
|---------------------|---------------------------|
| Super + Q           | Close window              |
| Super + V           | Toggle floating           |
| Super + F           | Toggle fullscreen         |
| Super + J           | Toggle split              |
| Super + P           | Pseudo-tile               |
| Super + Mouse1      | Move window               |
| Super + Mouse2      | Resize window             |

### Focus & Navigation
| Key                 | Action                    |
|---------------------|---------------------------|
| Super + ←/→/↑/↓     | Move focus                |
| Super + h/j/k/l     | Move focus (Vim keys)     |
| Super + 1-9         | Switch workspace          |
| Super + Shift + 1-9 | Move to workspace         |
| Super + S           | Toggle scratchpad         |
| Super + Mouse Wheel | Switch workspace          |

### System
| Key                      | Action                |
|--------------------------|-----------------------|
| Super + Shift + E        | Exit Hyprland         |
| Print Screen             | Screenshot to clipboard|
| Shift + Print Screen     | Screenshot to file    |

### Media (Laptop Function Keys)
| Key                      | Action                |
|--------------------------|-----------------------|
| XF86AudioRaiseVolume     | Volume up             |
| XF86AudioLowerVolume     | Volume down           |
| XF86AudioMute            | Mute toggle           |
| XF86MonBrightnessUp      | Brightness up         |
| XF86MonBrightnessDown    | Brightness down       |
| XF86AudioPlay            | Play/Pause            |
| XF86AudioNext            | Next track            |
| XF86AudioPrev            | Previous track        |

## Essential NixOS Commands

### System Management
```bash
# Rebuild system after config changes
sudo nixos-rebuild switch

# Test config without setting it as default
sudo nixos-rebuild test

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete old generations (free space)
sudo nix-collect-garbage -d

# Update channel and rebuild
sudo nixos-rebuild switch --upgrade

# Check system configuration
nixos-option system.stateVersion
```

### Package Management
```bash
# Search for packages
nix-env -qaP <package-name>
# Or online: https://search.nixos.org/

# IMPORTANT: Don't use nix-env -i
# Instead, add to configuration.nix

# Temporary shell with package (doesn't install)
nix-shell -p <package-name>

# Run package without installing
nix run nixpkgs#<package-name>
```

### Configuration Files
```bash
# Main system config
sudo nano /etc/nixos/configuration.nix

# Hardware config (auto-generated, don't edit usually)
sudo nano /etc/nixos/hardware-configuration.nix

# Rebuild after editing
sudo nixos-rebuild switch
```

### User Dotfiles
```bash
# Hyprland
nano ~/.config/hypr/hyprland.conf

# Waybar
nano ~/.config/waybar/config
nano ~/.config/waybar/style.css

# Kitty
nano ~/.config/kitty/kitty.conf

# Wofi
nano ~/.config/wofi/config
nano ~/.config/wofi/style.css

# Mako
nano ~/.config/mako/config
```

## Network Management

### NetworkManager (GUI)
```bash
nm-applet  # System tray icon

# Or terminal UI:
nmtui

# Or command line:
nmcli device wifi list
nmcli device wifi connect <SSID> password <password>
nmcli connection show
```

## Audio Management

### PipeWire/PulseAudio
```bash
# GUI volume control
pavucontrol

# Command line
wpctl status              # Show audio devices
wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

## Bluetooth

```bash
# GUI
blueman-manager

# Terminal
bluetoothctl
# Then in bluetoothctl:
power on
scan on
pair XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
```

## System Monitoring

```bash
# Top-like interfaces
htop      # Classic
btop      # Beautiful
nvtop     # GPU monitor (NVIDIA)

# Disk usage
ncdu      # Interactive
df -h     # Simple

# System info
neofetch
```

## NVIDIA GPU Commands (Laptop Only)

```bash
# Check GPU status
nvidia-smi

# Monitor GPU in real-time
watch -n 1 nvidia-smi

# Run app with NVIDIA GPU (offload mode)
nvidia-offload <command>
# Example: nvidia-offload glxinfo

# Check which GPU is being used
glxinfo | grep "OpenGL renderer"

# GPU monitoring
nvtop
```

## File Management

### Thunar (GUI)
- Press `Ctrl+H` to show hidden files
- Right-click for context menu
- `Ctrl+L` for location bar

### Terminal
```bash
# Navigate
cd <directory>
ls -la
pwd

# File operations
cp <source> <dest>      # Copy
mv <source> <dest>      # Move/rename
rm <file>               # Delete
mkdir <directory>       # Create directory
touch <file>            # Create file

# Permissions
chmod +x <file>         # Make executable
```

## Screenshots

```bash
# Take screenshot of area (to clipboard)
grim -g "$(slurp)" - | wl-copy

# Take screenshot of area (to file)
grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')

# Or use the keybindings:
# Print Screen = clipboard
# Shift + Print Screen = file
```

## Power Management (Laptop)

```bash
# Battery status
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# Current power profile
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check TLP status
sudo tlp-stat

# Laptop mode status
cat /proc/sys/vm/laptop_mode
```

## Logs & Debugging

```bash
# System logs
journalctl -xe          # Recent errors
journalctl -f           # Follow logs
journalctl -b           # Since last boot
journalctl -u <service> # Specific service

# Hyprland logs
cat ~/.hyprland.log

# Check if service is running
systemctl status <service>
systemctl --user status <service>  # User services

# Restart service
sudo systemctl restart <service>
systemctl --user restart <service>  # User services
```

## Git Basics (Version Control)

```bash
# Clone repository
git clone <url>

# Check status
git status

# Stage changes
git add <file>
git add .              # All files

# Commit
git commit -m "message"

# Push to remote
git push

# Pull from remote
git pull

# Create branch
git checkout -b <branch-name>
```

## Useful Tips

### Reload Hyprland Config
```bash
# Kill and restart Hyprland
Super + Shift + E  # Exit Hyprland
Hyprland           # Start again

# Or from terminal:
hyprctl reload
```

### Reload Waybar
```bash
# Waybar auto-reloads on config change
# Or manually:
killall waybar
waybar &
```

### Edit Configuration Safely
```bash
# Before major changes, backup:
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup

# Test without making default:
sudo nixos-rebuild test

# If test works, make it permanent:
sudo nixos-rebuild switch

# If something breaks:
sudo nixos-rebuild switch --rollback
```

### Free Up Disk Space
```bash
# Remove old generations
sudo nix-collect-garbage -d

# Remove old boot entries
sudo /run/current-system/bin/switch-to-configuration boot
```

### Check Available Disk Space
```bash
df -h /
```

### Update Everything
```bash
# Update NixOS
sudo nixos-rebuild switch --upgrade

# Clean old stuff
sudo nix-collect-garbage -d
```

## Emergency: System Won't Boot

1. Boot from NixOS USB
2. Mount your system:
   ```bash
   sudo mount /dev/sda3 /mnt
   sudo mount /dev/sda1 /mnt/boot
   ```
3. Enter system:
   ```bash
   sudo nixos-enter
   ```
4. Fix config and rebuild:
   ```bash
   nano /etc/nixos/configuration.nix
   nixos-rebuild switch
   ```
5. Reboot

## Resources

- NixOS Search: https://search.nixos.org/
- NixOS Manual: https://nixos.org/manual/nixos/stable/
- Hyprland Wiki: https://wiki.hyprland.org/
- NixOS Wiki: https://nixos.wiki/
- NixOS Discourse: https://discourse.nixos.org/

## Quick Customization

### Change Wallpaper
```bash
swww img /path/to/wallpaper.jpg
```

### Change Theme Colors
Edit files in:
- `~/.config/waybar/style.css` (bar colors)
- `~/.config/kitty/kitty.conf` (terminal colors)
- `~/.config/hypr/hyprland.conf` (window borders)

### Add Keybinding
Edit `~/.config/hypr/hyprland.conf`:
```
bind = $mainMod, <key>, exec, <command>
```

Remember: NixOS is declarative - always edit configuration.nix for system changes!
