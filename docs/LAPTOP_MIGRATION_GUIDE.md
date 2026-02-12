# Laptop Migration Guide
## Moving from NixOS VM to HP Victus Laptop

### Pre-Migration Checklist

Before you wipe Windows and install NixOS:

#### 1. Backup Everything
- [ ] Important files from Windows
- [ ] Browser bookmarks/passwords
- [ ] SSH keys, GPG keys
- [ ] Application settings you want to keep
- [ ] License keys for software

#### 2. Prepare Installation Media
- [ ] Download NixOS ISO (latest stable): https://nixos.org/download.html
- [ ] Create bootable USB using Rufus (on Windows) or `dd` (on Linux)
- [ ] Test booting from USB to ensure it works

#### 3. Document Your Hardware
```bash
# Run these commands on your VM to understand what to look for on laptop
lspci  # List PCI devices
lsusb  # List USB devices
```

### Installation Process

#### Step 1: Boot from USB
1. Insert USB drive
2. Restart laptop
3. Press F9 (or ESC/F2) to enter boot menu
4. Select USB drive
5. Choose "NixOS Installer" from boot menu

#### Step 2: Partition Setup

The installer will guide you, but here's the recommended layout for 512GB SSD:

```bash
# Check available disks
lsblk

# Example partitioning (adjust /dev/sdX to your actual disk)
# WARNING: This will erase ALL data on the disk!

# Using gdisk or parted:
# /dev/sda1: 512MB  EFI System Partition
# /dev/sda2: 16GB   Swap (2x your RAM)
# /dev/sda3: ~495GB Root partition (ext4)
```

If using the graphical installer, it will handle this for you.

#### Step 3: Basic Installation

Follow the NixOS installer, and when it creates `/mnt/etc/nixos/configuration.nix`:

1. **Don't use it yet** - we'll replace it
2. Complete the installation
3. Reboot into the new system

#### Step 4: Post-Installation Configuration

After booting into your fresh NixOS install:

1. **Find your GPU Bus IDs**:
```bash
lspci | grep -E "VGA|3D"
# Example output:
# 00:02.0 VGA compatible controller: Intel Corporation ...
# 01:00.0 3D controller: NVIDIA Corporation GA107M [GeForce RTX 2050] ...
#
# This means:
# Intel: PCI:0:2:0
# NVIDIA: PCI:1:0:0
```

2. **Update the laptop configuration**:
```bash
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
sudo nano /etc/nixos/configuration.nix
```

Copy the contents from `configuration-laptop.nix` and update these lines:
```nix
intelBusId = "PCI:0:2:0";   # Your Intel bus ID
nvidiaBusId = "PCI:1:0:0";  # Your NVIDIA bus ID
```

3. **Rebuild the system**:
```bash
sudo nixos-rebuild switch
```

This will take some time as it downloads NVIDIA drivers and other packages.

4. **Reboot**:
```bash
sudo reboot
```

#### Step 5: Install Dotfiles

After logging in:

```bash
# Create directories
mkdir -p ~/.config/{hypr,waybar,kitty,wofi,mako}
mkdir -p ~/Pictures/Screenshots

# Copy your dotfiles (from USB or clone from Git)
cp hyprland.conf ~/.config/hypr/hyprland.conf
cp waybar-config.json ~/.config/waybar/config
cp waybar-style.css ~/.config/waybar/style.css
cp kitty.conf ~/.config/kitty/kitty.conf
cp wofi-config ~/.config/wofi/config
cp wofi-style.css ~/.config/wofi/style.css
cp mako-config ~/.config/mako/config
```

5. **Update Hyprland config for 144Hz**:
```bash
nano ~/.config/hypr/hyprland.conf
```

Find the monitor section and update:
```
# Comment out VM setting:
# monitor=,preferred,auto,1

# Uncomment laptop setting:
monitor=eDP-1,1920x1080@144,0x0,1

# Or auto-detect with 144Hz preferred:
monitor=,preferred,auto,1
monitor=,highrr,auto,1  # Prefer highest refresh rate
```

6. **Start Hyprland**:
```bash
Hyprland
```

### Verifying Everything Works

#### Check NVIDIA
```bash
# Check if NVIDIA driver loaded
nvidia-smi

# Check if GPU is detected
lspci | grep -i nvidia

# Test GPU offloading
nvidia-offload glxinfo | grep "OpenGL renderer"
```

#### Check 144Hz Display
```bash
# In Hyprland, check current refresh rate
hyprctl monitors
```

Should show:
```
Monitor eDP-1 (ID 0):
    1920x1080@144.00Hz at 0x0
    ...
```

#### Check Audio
```bash
# List audio devices
pactl list sinks short

# Play test sound
speaker-test -t wav -c 2
```

#### Check Brightness Control
```bash
# Get current brightness
brightnessctl get

# Set brightness to 50%
brightnessctl set 50%
```

#### Check Battery
```bash
# Check battery status
upower -i /org/freedesktop/UPower/devices/battery_BAT0
```

### Performance Optimization

#### 1. NVIDIA Offload vs Sync Mode

**Current setup: Offload mode (default)**
- Uses Intel GPU for most tasks (better battery)
- Uses NVIDIA for demanding applications
- Run apps with NVIDIA: `nvidia-offload <command>`

**To switch to Sync mode (always NVIDIA):**

Edit `/etc/nixos/configuration.nix`:
```nix
# Comment out offload:
# prime.offload = {
#   enable = true;
#   enableOffloadCmd = true;
# };

# Enable sync:
prime.sync.enable = true;
```

Then: `sudo nixos-rebuild switch`

#### 2. Check Power Profile
```bash
# See current governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# On battery should show: powersave
# On AC should show: performance
```

#### 3. Monitor Temperatures
```bash
# Install if needed, but should be in config
btop  # or nvtop for GPU
```

### Troubleshooting Common Issues

#### Display Issues

**Black screen after boot:**
```bash
# Boot with nomodeset kernel parameter
# At boot, press 'e' in grub, add 'nomodeset' to kernel line
```

**Screen tearing:**
```bash
# Edit hyprland.conf, add:
decoration {
    screen_shader = "~/.config/hypr/shaders/crt.frag"  # optional
}

# Or force full composition pipeline
```

**Wrong refresh rate:**
```bash
# Check available modes
hyprctl monitors

# Force 144Hz in hyprland.conf:
monitor=eDP-1,1920x1080@144,0x0,1
```

#### NVIDIA Issues

**NVIDIA not working:**
```bash
# Check if module loaded
lsmod | grep nvidia

# Check kernel messages
sudo dmesg | grep -i nvidia

# Rebuild with nvidia driver
sudo nixos-rebuild switch --option tarball-ttl 0
```

**GPU not detected:**
```bash
# Verify bus IDs are correct
lspci | grep -E "VGA|3D"

# Update in configuration.nix
```

#### Battery Draining Too Fast

```bash
# Check what's using power
sudo powertop

# Enable all battery optimizations in TLP config
# Already configured in configuration-laptop.nix

# Consider enabling charge thresholds
# Uncomment in configuration-laptop.nix:
# START_CHARGE_THRESH_BAT0 = 75;
# STOP_CHARGE_THRESH_BAT0 = 80;
```

#### WiFi Issues

```bash
# Check if WiFi card detected
lspci | grep -i network

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Connect using nmtui
nmtui
```

#### Bluetooth Issues

```bash
# Check if bluetooth is running
systemctl status bluetooth

# Restart bluetooth
sudo systemctl restart bluetooth

# Connect using bluetoothctl
bluetoothctl
# > power on
# > scan on
# > pair XX:XX:XX:XX:XX:XX
# > connect XX:XX:XX:XX:XX:XX
```

### Recommended Next Steps

1. **Set up automatic backups**
   - Add Timeshift or Restic to configuration.nix
   - Back up to external drive

2. **Configure development environment**
   - Add your preferred programming languages
   - Set up Docker if needed (already commented in config)

3. **Install additional software**
   - Add to configuration.nix, not with `nix-env`
   - This keeps everything declarative

4. **Learn NixOS specifics**
   - How to roll back: `sudo nixos-rebuild switch --rollback`
   - How to upgrade: `sudo nixos-rebuild switch --upgrade`
   - How to clean old generations: `sudo nix-collect-garbage -d`

5. **Optimize for your workflow**
   - Customize Hyprland keybindings
   - Add workspace rules for specific apps
   - Configure monitors if you use external displays

### Dual Boot (Optional)

If you want to keep Windows:

1. **Shrink Windows partition first** (in Windows Disk Management)
2. **Install NixOS** in free space
3. **systemd-boot** will auto-detect Windows
4. You can choose OS at boot

To add Windows to boot menu after installation:
```bash
# Windows should auto-detect, but if not:
sudo nixos-rebuild switch
# systemd-boot will scan for other OSes
```

### Emergency Recovery

If something goes wrong:

1. **Boot from NixOS USB**
2. **Mount your installation**:
```bash
sudo mount /dev/sda3 /mnt  # Root partition
sudo mount /dev/sda1 /mnt/boot  # EFI partition
```

3. **Chroot into system**:
```bash
sudo nixos-enter
```

4. **Fix configuration and rebuild**:
```bash
nano /etc/nixos/configuration.nix
nixos-rebuild switch
```

5. **Reboot**

### Files to Keep Safe

Create a backup of these before wiping the VM:

- `/etc/nixos/configuration.nix`
- `~/.config/hypr/hyprland.conf`
- `~/.config/waybar/*`
- `~/.config/kitty/kitty.conf`
- `~/.config/wofi/*`
- `~/.config/mako/config`
- `~/.ssh/` (if you have SSH keys)
- `~/.gitconfig`

**Recommended: Create a Git repository**
```bash
mkdir ~/nixos-config
cp /etc/nixos/configuration.nix ~/nixos-config/
cp -r ~/.config/{hypr,waybar,kitty,wofi,mako} ~/nixos-config/dotfiles/
cd ~/nixos-config
git init
git add .
git commit -m "NixOS configuration backup"
# Push to GitHub/GitLab
```

This way you can easily restore on the laptop!

### Resources

- NixOS Manual: https://nixos.org/manual/nixos/stable/
- Hyprland Wiki: https://wiki.hyprland.org/
- NVIDIA on NixOS: https://nixos.wiki/wiki/Nvidia
- NixOS Discourse: https://discourse.nixos.org/

Good luck with the migration! Take it slow, test everything in the VM first, and keep backups!
