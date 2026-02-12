# NixOS Configuration for HP Victus Laptop
# i5, NVIDIA RTX 2050, 144Hz display, 8GB RAM, 512GB storage
#
# This configuration is for LAPTOP HARDWARE ONLY
# Use the main configuration.nix for VM testing
#
# IMPORTANT: When installing on laptop:
# 1. Remove or comment out virtualisation.virtualbox.guest section
# 2. Uncomment all laptop-specific sections below
# 3. Update hardware-configuration.nix after installation

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  
  # Kernel parameters for better performance
  boot.kernelParams = [ 
    "quiet" 
    "splash"
    "nvidia-drm.modeset=1"  # Enable NVIDIA DRM kernel mode setting
  ];

  # Networking
  networking.hostName = "jarvis"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [];

  # Time zone and locale and internationalisation
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with PipeWire
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  # Hardware configuration
  hardware = {
    # CPU microcode updates
    cpu.intel.updateMicrocode = true;
    
    # NVIDIA Configuration for RTX 2050
    nvidia = {
      modesetting.enable = true;
      
      # Power management (important for laptops)
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      
      # Use the open source version of the kernel module (for newer GPUs)
      # Set to false if you have issues
      open = false;
      
      # Enable the NVIDIA settings menu
      nvidiaSettings = true;
      
      # Select the appropriate driver version
      # Use "stable" for most cases, "beta" for latest features
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      
      # Optimus PRIME configuration (Intel + NVIDIA)
      prime = {
        # Make sure to set these after installation based on lspci output:
        # Run: lspci | grep -E "VGA|3D"
        # Find the bus IDs for Intel and NVIDIA
        
        # Offload mode - uses Intel by default, NVIDIA when needed (recommended for battery)
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        
        # Sync mode - always uses NVIDIA (better performance, worse battery)
        # sync.enable = true;
        
        # Replace these with actual values from lspci
        # Example: "PCI:0:2:0" for Intel, "PCI:1:0:0" for NVIDIA
        intelBusId = "PCI:0:2:0";  # UPDATE THIS
        nvidiaBusId = "PCI:1:0:0"; # UPDATE THIS
      };
    };
    
    # OpenGL/Graphics
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  # Services for bluetooth
  services.blueman.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # Environment variables for NVIDIA
  environment.sessionVariables = {
    # NVIDIA specific
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    # Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    
    # Enable NVIDIA GPU for Hyprland
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;

  # Power management with TLP (better battery life)
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # CPU boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # CPU frequencies
      CPU_SCALING_MIN_FREQ_ON_AC = 800000;
      CPU_SCALING_MAX_FREQ_ON_AC = 4500000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;
      
      # Runtime PM for PCI(e) devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # Battery care (stops charging at 80% to prolong battery life)
      # START_CHARGE_THRESH_BAT0 = 75;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Thermald for temperature management
  services.thermald.enable = true;

  # Laptop power management
  services.upower.enable = true;
  
  # Auto-mounting of USB drives
  services.udisks2.enable = true;
  
  # Firmware updates
  services.fwupd.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.ashdev = {
    isNormalUser = true;
    description = "Ashish Birajdar";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ]; # Enable sudo for the user.
    packages = with pkgs; [
      # Web browsers
      firefox
      
      # Terminal and shell
      kitty
      starship
      zsh
      
      # File management
      thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      
      # Text editors
      neovim
      
      # Hyprland ecosystem
      waybar
      wofi
      mako
      swww  # Wallpaper daemon
      
      # Screenshots and screen recording
      grim
      slurp
      wl-clipboard
      wf-recorder  # Screen recording
      
      # PDF viewer
      zathura
      
      # Image viewer
      imv
      
      # System utilities
      htop
      btop
      ncdu
      tree
      
      # Archive management
      unzip
      zip
      p7zip
      unrar
      
      # Network tools
      wget
      curl
      
      # Git
      git
      gh  # GitHub CLI
      
      # NVIDIA utilities
      nvtopPackages.full  # GPU monitoring
      
      # GPU offload helper scripts are automatically available via hardware.nvidia.prime.offload.enableOffloadCmd
    ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    networkmanagerapplet  # Network manager tray icon
    pavucontrol  # PulseAudio volume control
    polkit_gnome  # Polkit authentication agent
    
    # Wayland essentials
    wayland
    wayland-protocols
    wayland-utils
    wl-clipboard
    
    # Additional utilities
    brightnessctl  # Screen brightness control
    playerctl  # Media player control
    
    # Bluetooth
    bluez
    bluez-tools
    
    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Font configuration
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Enable zsh system-wide
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
    };
  };

  # Enable dconf (required for some applications)
  programs.dconf.enable = true;

  # Enable thunar plugins
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # === IMPORTANT: DISABLE THIS SECTION ON LAPTOP ===
  # VirtualBox guest setup (VM ONLY - REMOVE/COMMENT OUT FOR LAPTOP)
  # virtualisation.virtualbox.guest = {
  #   enable = true;
  #   seamless = true;
  #   clipboard = true;
  #   dragAndDrop = true;
  #   x11 = false;
  # };
  # === END OF VM-ONLY SECTION ===

  # Docker (optional - uncomment if you need it)
  # virtualisation.docker.enable = true;
  # virtualisation.docker.enableNvidia = true;  # Enable NVIDIA GPU in Docker

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system — see https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
