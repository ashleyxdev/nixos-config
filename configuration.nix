# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = null;

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

  # Enable cpu microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.ashdev = {
    isNormalUser = true;
    description = "Ashish Birajdar";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ]; # Enable sudo for the user.
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
    brightnessctl  # Screen brightness control (for laptop)
    playerctl  # Media player control
    
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

  # VirtualBox guest setup (VM only - will be disabled on laptop)
  virtualisation.virtualbox.guest = {
    enable = true;
    seamless = true;
    clipboard = true;
    dragAndDrop = true;
    x11 = false;  # Not needed with Wayland
  };

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
