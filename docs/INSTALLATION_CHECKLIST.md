# Installation Checklist

Use this checklist to track your progress through the setup process.

## Phase 1: VM Testing (Do This First!)

### Pre-Installation
- [ ] Downloaded all configuration files to your Windows host
- [ ] Transferred files to your NixOS VM (via shared folder, scp, or git)
- [ ] Read README.md to understand the setup
- [ ] Read SETUP_GUIDE.md for detailed instructions

### VM Deployment
- [ ] Backed up current configuration: `sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup`
- [ ] Ran deployment script: `./deploy.sh`
- [ ] System rebuilt successfully without errors
- [ ] Rebooted the system

### First Boot Testing
- [ ] Hyprland starts (run `Hyprland` from TTY)
- [ ] Can see desktop with Waybar at the top
- [ ] Wallpaper displayed (or dark background)
- [ ] No error messages visible

### Keyboard & Mouse Testing
- [ ] Super + Return opens terminal (Kitty)
- [ ] Super + D opens application launcher (Wofi)
- [ ] Super + Q closes windows
- [ ] Super + E opens file manager (Thunar)
- [ ] Can switch workspaces with Super + 1-9
- [ ] Mouse cursor moves smoothly
- [ ] Can drag windows with Super + Mouse1
- [ ] Can resize windows with Super + Mouse2

### Application Testing
- [ ] Firefox opens and can browse websites
- [ ] Terminal (Kitty) works and looks good
- [ ] File manager (Thunar) can browse files
- [ ] Can open text files with Neovim
- [ ] Wofi launcher shows applications

### System Integration Testing
- [ ] Audio works: `speaker-test -t wav -c 2`
- [ ] Volume controls work (in Waybar or with keys)
- [ ] Network connectivity works
- [ ] Clipboard works (copy/paste between apps)
- [ ] VirtualBox clipboard integration works (host ↔ VM)
- [ ] VirtualBox drag-and-drop works

### Screenshot Testing
- [ ] Print Screen captures area to clipboard
- [ ] Shift + Print Screen saves to ~/Pictures/Screenshots/
- [ ] Can paste screenshots

### Visual Testing
- [ ] Waybar displays all modules (time, CPU, RAM, network, etc.)
- [ ] Waybar looks good (no overlapping text)
- [ ] Window borders visible and colored
- [ ] Animations smooth (window open/close)
- [ ] No screen tearing
- [ ] Colors look good in terminal

### Configuration Testing
- [ ] Edit hyprland.conf and reload: `hyprctl reload`
- [ ] Changes take effect
- [ ] Edit waybar config: auto-reloads
- [ ] NixOS rebuild works: `sudo nixos-rebuild switch`
- [ ] Can rollback: `sudo nixos-rebuild switch --rollback`

### Learning Phase
- [ ] Practiced using keybindings for 10+ minutes
- [ ] Customized at least one color or setting
- [ ] Added at least one package to configuration.nix
- [ ] Successfully rebuilt system with new package
- [ ] Read QUICK_REFERENCE.md
- [ ] Comfortable with basic workflow

### Advanced VM Testing
- [ ] Tested installing additional software
- [ ] Tested removing software (edit config, rebuild)
- [ ] Tested system updates: `sudo nixos-rebuild switch --upgrade`
- [ ] Tested cleanup: `sudo nix-collect-garbage -d`
- [ ] Created a backup of your configuration
- [ ] Know how to restore from backup

---

## Phase 2: Laptop Preparation (Before Installing)

### Documentation Review
- [ ] Read LAPTOP_MIGRATION_GUIDE.md completely
- [ ] Understand the differences between VM and laptop config
- [ ] Know how to find GPU bus IDs
- [ ] Know what changes are needed in configuration-laptop.nix

### Windows Backup
- [ ] Backed up all important files to external drive
- [ ] Exported browser bookmarks and passwords
- [ ] Saved any license keys needed
- [ ] Backed up SSH/GPG keys (if you have them)
- [ ] Backed up application settings you want to keep
- [ ] Took screenshots of Windows settings you want to remember
- [ ] Verified backups are readable

### Installation Media
- [ ] Downloaded latest NixOS ISO
- [ ] Created bootable USB (using Rufus on Windows)
- [ ] Tested USB boots on laptop (without installing)
- [ ] Can access boot menu (usually F9 on HP Victus)

### Configuration Preparation
- [ ] Updated configuration-laptop.nix with your preferences
- [ ] Saved all config files to USB or Git repository
- [ ] Have a copy of all dotfiles ready
- [ ] Know where to find your configs after installation

### Mental Preparation
- [ ] Understand this will wipe Windows completely
- [ ] Comfortable with Hyprland workflow from VM testing
- [ ] Know basic NixOS commands
- [ ] Have time set aside (2-3 hours minimum)
- [ ] Ready to troubleshoot if needed

---

## Phase 3: Laptop Installation

### BIOS Settings
- [ ] Disabled Secure Boot (if needed)
- [ ] Set boot order (USB first)
- [ ] Saved BIOS settings

### NixOS Installation
- [ ] Booted from USB successfully
- [ ] Started NixOS installer
- [ ] Connected to WiFi
- [ ] Partitioned disk (512MB EFI, 16GB swap, rest for /)
- [ ] Installed base system
- [ ] System reboots successfully

### Post-Installation Configuration
- [ ] Booted into fresh NixOS installation
- [ ] Found GPU bus IDs: `lspci | grep -E "VGA|3D"`
- [ ] Copied configuration-laptop.nix to /etc/nixos/configuration.nix
- [ ] Updated GPU bus IDs in configuration.nix
- [ ] Rebuilt system: `sudo nixos-rebuild switch`
- [ ] System rebuilt without errors
- [ ] Rebooted

### Dotfiles Installation
- [ ] Created ~/.config directories
- [ ] Copied all dotfiles to correct locations
- [ ] Updated hyprland.conf for 144Hz display
- [ ] Verified all configs are in place

### First Laptop Boot
- [ ] Started Hyprland successfully
- [ ] Desktop looks correct
- [ ] Waybar shows system information

---

## Phase 4: Laptop Hardware Verification

### Display
- [ ] 144Hz working: `hyprctl monitors` shows 144Hz
- [ ] Resolution correct (1920x1080)
- [ ] Colors look good
- [ ] No screen tearing
- [ ] Brightness control works: `brightnessctl set 50%`
- [ ] Can adjust brightness with function keys

### Graphics
- [ ] NVIDIA driver loaded: `nvidia-smi`
- [ ] GPU detected correctly
- [ ] Can run apps with NVIDIA: `nvidia-offload glxinfo`
- [ ] Intel GPU working for desktop (better battery)
- [ ] No graphics glitches

### Audio
- [ ] Speakers work
- [ ] Headphone jack works
- [ ] Microphone works (if you have one)
- [ ] Volume keys work
- [ ] Can adjust volume in pavucontrol
- [ ] No audio crackling

### Network
- [ ] WiFi connects successfully
- [ ] Internet works
- [ ] Can browse websites
- [ ] Download speeds reasonable
- [ ] WiFi doesn't disconnect randomly

### Input Devices
- [ ] Keyboard all keys work
- [ ] Function keys work (brightness, volume, etc.)
- [ ] Touchpad works
- [ ] Touchpad gestures work (two-finger scroll, etc.)
- [ ] Tap-to-click works
- [ ] Can disable touchpad while typing

### Power Management
- [ ] Battery detected: `upower -i /org/freedesktop/UPower/devices/battery_BAT0`
- [ ] Battery percentage shows in Waybar
- [ ] AC adapter detection works
- [ ] CPU governor changes on AC/battery
- [ ] TLP running: `sudo tlp-stat`
- [ ] System doesn't overheat during use

### Thermal Management
- [ ] Fans spin up under load
- [ ] System stays cool during normal use
- [ ] CPU temps reasonable: check with `btop`
- [ ] GPU temps reasonable: check with `nvtop`
- [ ] Thermald running

### Bluetooth (if you need it)
- [ ] Bluetooth service running
- [ ] Can pair devices
- [ ] Audio works over Bluetooth
- [ ] Devices reconnect after reboot

---

## Phase 5: Final Setup & Optimization

### Performance Tuning
- [ ] Tested NVIDIA offload mode (default)
- [ ] Decided if sync mode is needed
- [ ] Battery life acceptable (4+ hours light use)
- [ ] No lag or stuttering during use

### Software Installation
- [ ] Added needed development tools to configuration.nix
- [ ] Added productivity apps
- [ ] Rebuilt system with all software
- [ ] All apps work correctly

### Customization
- [ ] Changed wallpaper to preferred image
- [ ] Customized colors if desired
- [ ] Set up custom keybindings
- [ ] Configured workspace rules
- [ ] Tweaked Waybar modules

### Data Migration
- [ ] Restored important files from backup
- [ ] Imported browser data
- [ ] Set up SSH keys
- [ ] Configured Git
- [ ] Restored application settings

### Backup Strategy
- [ ] Created Git repo for configs
- [ ] Pushed configs to GitHub/GitLab
- [ ] Tested restoring from Git repo
- [ ] Set up regular backups for home directory
- [ ] Know how to recover if system breaks

### Documentation
- [ ] Bookmarked essential resources
- [ ] Saved custom configurations
- [ ] Documented any hardware-specific tweaks
- [ ] Know where to get help

---

## Phase 6: Living With NixOS

### First Week
- [ ] Used system daily for a week
- [ ] No major issues encountered
- [ ] Comfortable with Hyprland workflow
- [ ] Can install software easily
- [ ] Can update system
- [ ] Can troubleshoot minor issues

### Maintenance
- [ ] Set up update schedule (weekly/monthly)
- [ ] Know how to clean old generations
- [ ] Monitor disk space usage
- [ ] Keep configs in version control

### Advanced Usage
- [ ] Explored NixOS features
- [ ] Tried nix-shell for projects
- [ ] Considered using Home Manager
- [ ] Joined NixOS community
- [ ] Helping others with NixOS

---

## Emergency Contacts & Resources

### If Something Goes Wrong
1. **Don't Panic**: You can always rollback
2. **Check Logs**: `journalctl -xe`
3. **Try TTY**: Ctrl+Alt+F2
4. **Boot from USB**: If needed for rescue

### Get Help
- NixOS Discourse: https://discourse.nixos.org/
- #nixos on Matrix/IRC
- r/NixOS on Reddit
- Your VM is still there for reference!

### Quick Fixes
- Won't boot: Boot from USB, chroot, fix config
- Black screen: Try TTY, check logs
- No WiFi: `nmtui` from TTY
- NVIDIA issues: Check bus IDs, driver version
- Audio issues: Check PipeWire status

---

## Success Criteria

You've successfully migrated to NixOS when:

- ✅ System boots reliably
- ✅ All hardware works (display, audio, WiFi, etc.)
- ✅ Comfortable with daily workflow
- ✅ Can update and maintain system
- ✅ Battery life acceptable
- ✅ No major bugs or issues
- ✅ Backed up and can restore configs
- ✅ Happy with the setup!

---

**Congratulations on your NixOS journey! 🎉**

Remember: The VM is your safe testing ground. Don't rush to the laptop until you're comfortable!
