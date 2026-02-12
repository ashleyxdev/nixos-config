#!/usr/bin/env bash
# NixOS Hyprland Configuration Deployment Script
# This script helps you deploy the configuration to your NixOS system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for system config
check_sudo() {
    if [ "$EUID" -eq 0 ]; then 
        print_error "Please run this script as a normal user, not root"
        print_info "The script will ask for sudo when needed"
        exit 1
    fi
}

# Detect if running in VM or on real hardware
detect_environment() {
    if lsmod | grep -q vboxguest; then
        ENV="vm"
        print_info "Detected VirtualBox VM environment"
    else
        ENV="laptop"
        print_info "Detected laptop/hardware environment"
    fi
}

# Backup existing configuration
backup_config() {
    print_info "Backing up existing configuration..."
    
    if [ -f /etc/nixos/configuration.nix ]; then
        BACKUP_FILE="/etc/nixos/configuration.nix.backup-$(date +%Y%m%d-%H%M%S)"
        sudo cp /etc/nixos/configuration.nix "$BACKUP_FILE"
        print_success "Backed up to $BACKUP_FILE"
    else
        print_warning "No existing configuration found"
    fi
}

# Deploy system configuration
deploy_system_config() {
    print_info "Deploying NixOS system configuration..."
    
    if [ "$ENV" = "vm" ]; then
        CONFIG_FILE="configuration.nix"
    else
        CONFIG_FILE="configuration-laptop.nix"
        print_warning "Using laptop configuration"
        print_warning "Make sure you've updated GPU bus IDs!"
        print_warning "Run: lspci | grep -E 'VGA|3D' to find them"
        read -p "Have you updated the GPU bus IDs? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Please update GPU bus IDs in configuration-laptop.nix first"
            exit 1
        fi
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        sudo cp "$CONFIG_FILE" /etc/nixos/configuration.nix
        print_success "Deployed $CONFIG_FILE to /etc/nixos/configuration.nix"
    else
        print_error "Configuration file $CONFIG_FILE not found"
        exit 1
    fi
}

# Create necessary directories
create_directories() {
    print_info "Creating necessary directories..."
    
    mkdir -p ~/.config/hypr
    mkdir -p ~/.config/waybar
    mkdir -p ~/.config/kitty
    mkdir -p ~/.config/wofi
    mkdir -p ~/.config/mako
    mkdir -p ~/Pictures/Screenshots
    
    print_success "Directories created"
}

# Deploy user dotfiles
deploy_dotfiles() {
    print_info "Deploying user configuration files..."
    
    # Hyprland
    if [ -f "hyprland.conf" ]; then
        cp hyprland.conf ~/.config/hypr/hyprland.conf
        print_success "Deployed Hyprland config"
    fi
    
    # Waybar
    if [ -f "waybar-config.json" ]; then
        cp waybar-config.json ~/.config/waybar/config
        print_success "Deployed Waybar config"
    fi
    
    if [ -f "waybar-style.css" ]; then
        cp waybar-style.css ~/.config/waybar/style.css
        print_success "Deployed Waybar styles"
    fi
    
    # Kitty
    if [ -f "kitty.conf" ]; then
        cp kitty.conf ~/.config/kitty/kitty.conf
        print_success "Deployed Kitty config"
    fi
    
    # Wofi
    if [ -f "wofi-config" ]; then
        cp wofi-config ~/.config/wofi/config
        print_success "Deployed Wofi config"
    fi
    
    if [ -f "wofi-style.css" ]; then
        cp wofi-style.css ~/.config/wofi/style.css
        print_success "Deployed Wofi styles"
    fi
    
    # Mako
    if [ -f "mako-config" ]; then
        cp mako-config ~/.config/mako/config
        print_success "Deployed Mako config"
    fi
}

# Update monitor config for laptop
update_monitor_config() {
    if [ "$ENV" = "laptop" ]; then
        print_info "Updating monitor configuration for 144Hz..."
        
        sed -i 's/^monitor=,preferred,auto,1/# monitor=,preferred,auto,1/' ~/.config/hypr/hyprland.conf
        sed -i 's/^# monitor=eDP-1,1920x1080@144,0x0,1/monitor=eDP-1,1920x1080@144,0x0,1/' ~/.config/hypr/hyprland.conf
        
        print_success "Monitor config updated for 144Hz"
    fi
}

# Rebuild NixOS
rebuild_system() {
    print_info "Rebuilding NixOS system..."
    print_warning "This may take a while (10-20 minutes on first run)..."
    
    if sudo nixos-rebuild switch; then
        print_success "System rebuilt successfully!"
    else
        print_error "System rebuild failed"
        print_info "Check errors above and fix configuration"
        print_info "To rollback: sudo nixos-rebuild switch --rollback"
        exit 1
    fi
}

# Print next steps
print_next_steps() {
    echo
    print_success "=== Deployment Complete! ==="
    echo
    print_info "Next steps:"
    echo "  1. Reboot your system: sudo reboot"
    echo "  2. After reboot, select Hyprland from login screen (or run 'Hyprland' from TTY)"
    echo "  3. Read SETUP_GUIDE.md for keybindings and usage"
    echo "  4. Read QUICK_REFERENCE.md for quick command reference"
    
    if [ "$ENV" = "laptop" ]; then
        echo
        print_warning "Laptop-specific reminders:"
        echo "  - Test NVIDIA GPU: nvidia-smi"
        echo "  - Check 144Hz: hyprctl monitors"
        echo "  - Test brightness: brightnessctl set 50%"
        echo "  - Monitor battery: upower -i /org/freedesktop/UPower/devices/battery_BAT0"
    fi
    
    echo
    print_info "Useful commands:"
    echo "  - Show all keybindings: cat ~/.config/hypr/hyprland.conf | grep '^bind'"
    echo "  - Reload Hyprland: hyprctl reload"
    echo "  - Check logs: journalctl -xe"
    
    if [ "$ENV" = "vm" ]; then
        echo
        print_info "VM Testing checklist:"
        echo "  [ ] Hyprland starts and looks good"
        echo "  [ ] Can open terminal (Super+Return)"
        echo "  [ ] Can launch apps (Super+D)"
        echo "  [ ] Audio works (test with 'speaker-test')"
        echo "  [ ] Network works"
        echo "  [ ] Clipboard works between host and VM"
        echo "  [ ] All dotfiles are working as expected"
        echo
        print_info "Once everything works in VM, you're ready for laptop migration!"
        print_info "Read LAPTOP_MIGRATION_GUIDE.md before installing on laptop"
    fi
}

# Main deployment flow
main() {
    clear
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  NixOS Hyprland Configuration Deployment Script           ║"
    echo "║  Created for HP Victus (i5, RTX 2050, 144Hz)             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo
    
    check_sudo
    detect_environment
    
    echo
    print_warning "This script will:"
    echo "  1. Backup your current configuration"
    echo "  2. Deploy new NixOS configuration"
    echo "  3. Deploy user dotfiles"
    echo "  4. Rebuild your system"
    echo
    
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Deployment cancelled"
        exit 0
    fi
    
    echo
    backup_config
    deploy_system_config
    create_directories
    deploy_dotfiles
    update_monitor_config
    
    echo
    print_warning "Ready to rebuild system. This will download packages and may take a while."
    read -p "Proceed with system rebuild? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rebuild_system
    else
        print_info "Skipped system rebuild"
        print_warning "Remember to run 'sudo nixos-rebuild switch' manually later"
    fi
    
    print_next_steps
}

# Run main function
main
