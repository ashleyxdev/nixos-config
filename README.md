# NixOS Hyprland Configuration
## For HP Victus Laptop (i5, RTX 2050, 144Hz Display)

A complete, production-ready NixOS configuration with Hyprland compositor, designed to work seamlessly from VM testing to laptop deployment.

---

## 📋 Overview

This repository contains:
- **Complete NixOS system configuration** with Hyprland
- **Optimized for both VirtualBox VM** (testing) and **HP Victus laptop** (production)
- **NVIDIA Optimus support** (Intel + RTX 2050)
- **144Hz display configuration**
- **Modern, beautiful desktop** with Waybar, Wofi, and more
- **Power management** for laptop battery life
- **Full documentation** for deployment and usage

---

## 🎯 Features

### Desktop Environment
- **Hyprland** - Modern Wayland compositor with smooth animations
- **Waybar** - Customizable status bar with system info
- **Wofi** - Fast application launcher
- **Mako** - Notification daemon
- **Kitty** - GPU-accelerated terminal with beautiful colors

### Applications Included
- Firefox (web browser)
- Thunar (file manager)
- Neovim (text editor)
- Zathura (PDF viewer)
- Imv (image viewer)
- Git + GitHub CLI

### System Features
- ✅ NVIDIA Optimus support (Hybrid graphics)
- ✅ 144Hz display support
- ✅ Power management (TLP)
- ✅ Audio (PipeWire)
- ✅ Bluetooth
- ✅ Network Manager
- ✅ Screenshots & screen recording
- ✅ Brightness control
- ✅ Media keys support

---

## 📁 File Structure

```
.
├── configuration.nix              # NixOS config for VM testing
├── configuration-laptop.nix       # NixOS config for laptop hardware
├── hyprland.conf                  # Hyprland window manager config
├── waybar-config.json             # Waybar status bar config
├── waybar-style.css               # Waybar styling
├── kitty.conf                     # Kitty terminal config
├── wofi-config                    # Wofi launcher config
├── wofi-style.css                 # Wofi styling
├── mako-config                    # Mako notification daemon config
├── deploy.sh                      # Automated deployment script
├── SETUP_GUIDE.md                 # Detailed setup instructions
├── LAPTOP_MIGRATION_GUIDE.md      # Guide for moving VM → Laptop
├── QUICK_REFERENCE.md             # Command & keybinding reference
└── README.md                      # This file
```

---

## 🚀 Quick Start

### For VM Testing (Current)

1. **Transfer files to your VM**:
   ```bash
   # Mount shared folder or use scp/git
   ```

2. **Run deployment script**:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Reboot and start Hyprland**:
   ```bash
   sudo reboot
   # After reboot:
   Hyprland
   ```

### For Laptop Installation (After VM Testing)

1. **Read the migration guide**: `LAPTOP_MIGRATION_GUIDE.md`
2. **Backup everything important**
3. **Create NixOS installation USB**
4. **Install NixOS on laptop**
5. **Deploy laptop configuration**
6. **Enjoy your new system!**

---

## ⌨️ Essential Keybindings

### Quick Reference
| Key                 | Action                    |
|---------------------|---------------------------|
| `Super + Return`    | Open terminal             |
| `Super + D`         | Application launcher      |
| `Super + E`         | File manager              |
| `Super + Q`         | Close window              |
| `Super + 1-9`       | Switch workspace          |
| `Print Screen`      | Screenshot                |
| `Super + Shift + E` | Exit Hyprland             |

See `QUICK_REFERENCE.md` for complete keybinding list.

---

## 📖 Documentation

### Essential Reading
1. **SETUP_GUIDE.md** - Start here! Complete setup instructions
2. **QUICK_REFERENCE.md** - Keybindings and commands you'll use daily
3. **LAPTOP_MIGRATION_GUIDE.md** - Read before installing on laptop

### Configuration Files
- **configuration.nix** - VM configuration (use this first)
- **configuration-laptop.nix** - Laptop configuration (use after testing)
- **~/.config/hypr/hyprland.conf** - Window manager settings
- **~/.config/waybar/** - Status bar customization

---

## 🎨 Customization

### Change Colors/Theme
Edit these files:
- `~/.config/waybar/style.css` - Bar colors
- `~/.config/kitty/kitty.conf` - Terminal colors
- `~/.config/hypr/hyprland.conf` - Window border colors

### Add Software
**IMPORTANT**: Don't use `nix-env -i`

Instead, edit `/etc/nixos/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Add your packages here
  vscode
  discord
  # etc...
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

### Add Keybindings
Edit `~/.config/hypr/hyprland.conf`:
```
bind = $mainMod, <key>, exec, <command>
```

---

## 🔧 NixOS Basics

### Update System
```bash
sudo nixos-rebuild switch --upgrade
```

### Rollback Changes
```bash
sudo nixos-rebuild switch --rollback
```

### Clean Old Generations
```bash
sudo nix-collect-garbage -d
```

### Test Config Without Committing
```bash
sudo nixos-rebuild test
```

---

## 🐛 Troubleshooting

### System won't boot
Boot from NixOS USB, mount system, and fix config:
```bash
sudo mount /dev/sda3 /mnt
sudo mount /dev/sda1 /mnt/boot
sudo nixos-enter
# Fix /etc/nixos/configuration.nix
nixos-rebuild switch
```

### Hyprland won't start
```bash
# Check logs
journalctl -xe

# Try from TTY
Hyprland
```

### NVIDIA issues (laptop)
```bash
# Check if driver loaded
nvidia-smi

# Verify bus IDs
lspci | grep -E "VGA|3D"

# Update in /etc/nixos/configuration.nix
```

See `SETUP_GUIDE.md` for more troubleshooting.

---

## 📊 System Requirements

### VM (Testing)
- **RAM**: 2GB minimum, 3-4GB recommended
- **CPU**: 2 cores
- **Storage**: 30GB
- **VirtualBox**: 3D acceleration enabled, 128MB video memory

### Laptop (Production)
- **HP Victus** specs:
  - Intel i5 CPU
  - NVIDIA RTX 2050
  - 144Hz display
  - 8GB RAM
  - 512GB storage
- Or similar laptop with:
  - Intel + NVIDIA GPU
  - UEFI boot
  - 8GB+ RAM

---

## 🛠️ What to Do in the VM

### Testing Checklist
- [ ] Hyprland starts correctly
- [ ] Can navigate with keyboard
- [ ] Can launch applications
- [ ] Terminal works (Kitty)
- [ ] File manager works (Thunar)
- [ ] Browser works (Firefox)
- [ ] Audio works
- [ ] Network works
- [ ] Screenshots work
- [ ] All keybindings work
- [ ] Customizations work
- [ ] System updates work

### Learn the System
1. Practice using Hyprland keybindings
2. Customize colors and wallpapers
3. Add software you need
4. Test backups and rollbacks
5. Get comfortable with NixOS commands

---

## 🎯 Why This Setup?

### Hyprland
- Modern, beautiful, fast
- Wayland-native (better security, screen sharing)
- Highly customizable
- Great for both work and aesthetics

### NixOS
- **Declarative** - entire system in config files
- **Reproducible** - same config = same system
- **Rollback** - broke something? Rollback instantly
- **Atomic updates** - updates are all-or-nothing
- **No dependency hell** - each package has its dependencies

### This Configuration
- **Tested** in VM before laptop deployment
- **Documented** extensively
- **Modular** - easy to customize
- **Production-ready** - power management, NVIDIA, etc.
- **Beginner-friendly** - clear guides and references

---

## 📚 Learning Resources

### Official Documentation
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [NixOS Search](https://search.nixos.org/)

### Community
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [r/NixOS](https://www.reddit.com/r/NixOS/)

### Videos
- Search YouTube for "NixOS tutorial"
- "Hyprland setup" videos

---

## ⚠️ Important Notes

### Before Laptop Installation
1. **TEST EVERYTHING IN THE VM FIRST**
2. **Backup all important data from Windows**
3. **Read LAPTOP_MIGRATION_GUIDE.md completely**
4. **Have a NixOS installation USB ready**
5. **Know how to access BIOS/boot menu on your laptop**

### After Installation
- Don't panic if something doesn't work immediately
- You can always rollback with `nixos-rebuild switch --rollback`
- Check logs with `journalctl -xe`
- Ask for help on NixOS Discourse

### NixOS Philosophy
- **Everything in configuration.nix** - don't install packages with `nix-env`
- **Git your configs** - version control is your friend
- **Test in VM first** - always test major changes
- **Read error messages** - NixOS errors are usually helpful

---

## 🤝 Contributing

This is a personal configuration, but if you find bugs or improvements:
1. Test them in the VM
2. Document what you changed
3. Share your findings

---

## 📝 License

This configuration is provided as-is for personal use. Feel free to use, modify, and share.

---

## ✨ Credits

Built with:
- [NixOS](https://nixos.org/)
- [Hyprland](https://hyprland.org/)
- [Waybar](https://github.com/Alexays/Waybar)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Catppuccin color scheme](https://github.com/catppuccin/catppuccin)
- And many other amazing open-source projects

---

## 🎓 Next Steps

1. **Read SETUP_GUIDE.md** - Detailed setup instructions
2. **Deploy to VM** - Run `./deploy.sh`
3. **Test everything** - Use the testing checklist above
4. **Customize** - Make it yours!
5. **Learn NixOS** - Read the official manual
6. **Prepare for laptop** - Read LAPTOP_MIGRATION_GUIDE.md
7. **Deploy to laptop** - When you're ready!

---

**Happy hacking! 🚀**

Remember: NixOS is different, but once you get it, you'll never want to go back!
