# Development Environment Setup
## Add this to your configuration.nix based on your needs

# This file contains examples of development tools you might want to add
# Uncomment and add to your configuration.nix as needed

## === PROGRAMMING LANGUAGES ===

# Python Development
environment.systemPackages = with pkgs; [
  python311
  python311Packages.pip
  python311Packages.virtualenv
  python311Packages.setuptools
];

# Node.js/JavaScript Development
environment.systemPackages = with pkgs; [
  nodejs_20
  yarn
  nodePackages.npm
  nodePackages.pnpm
];

# Rust Development
environment.systemPackages = with pkgs; [
  rustc
  cargo
  rustfmt
  clippy
];

# Go Development
environment.systemPackages = with pkgs; [
  go
  gopls
  gotools
];

# C/C++ Development
environment.systemPackages = with pkgs; [
  gcc
  cmake
  gnumake
  gdb
  lldb
  clang-tools
];

# Java Development
environment.systemPackages = with pkgs; [
  jdk17
  maven
  gradle
];

## === DEVELOPMENT TOOLS ===

# Docker (requires enabling virtualisation.docker)
virtualisation.docker.enable = true;
virtualisation.docker.enableNvidia = true;  # For GPU in containers
users.users.ashdev.extraGroups = [ "docker" ];

# Podman (alternative to Docker)
virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  defaultNetwork.settings.dns_enabled = true;
};

# Database Tools
environment.systemPackages = with pkgs; [
  postgresql
  sqlite
  mongodb-tools
  redis
  mysql80
];

# Version Control
environment.systemPackages = with pkgs; [
  git
  gh              # GitHub CLI
  git-lfs
  lazygit         # TUI for git
  tig             # Another git TUI
];

# Text Editors / IDEs
environment.systemPackages = with pkgs; [
  vscode
  vscodium        # Open source VSCode
  neovim
  helix           # Modern modal editor
  zed-editor      # Modern collaborative editor
];

# Terminal Tools
environment.systemPackages = with pkgs; [
  tmux
  zellij          # Modern terminal multiplexer
  alacritty       # Alternative terminal
  wezterm         # GPU-accelerated terminal
  
  # Shell enhancements
  zsh
  oh-my-zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship        # Cross-shell prompt
  
  # CLI utilities
  fzf             # Fuzzy finder
  ripgrep         # Better grep
  fd              # Better find
  bat             # Better cat
  exa             # Better ls
  zoxide          # Better cd
  delta           # Better git diff
];

# API Testing
environment.systemPackages = with pkgs; [
  postman
  insomnia
  httpie
  curlie          # curl with httpie UI
];

## === CLOUD & DEVOPS ===

# Kubernetes
environment.systemPackages = with pkgs; [
  kubectl
  kubernetes-helm
  k9s             # TUI for k8s
  minikube
];

# Terraform
environment.systemPackages = with pkgs; [
  terraform
  terraform-ls
  tflint
];

# AWS
environment.systemPackages = with pkgs; [
  awscli2
  aws-vault
  ssm-session-manager-plugin
];

# Azure
environment.systemPackages = with pkgs; [
  azure-cli
];

# Google Cloud
environment.systemPackages = with pkgs; [
  google-cloud-sdk
];

## === BUILD TOOLS ===

environment.systemPackages = with pkgs; [
  gnumake
  cmake
  ninja
  meson
  bazel
];

## === NEOVIM CONFIGURATION ===

# Example minimal Neovim config with plugins
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  
  configure = {
    customRC = ''
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      syntax on
      set mouse=a
    '';
    
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        vim-nix
        telescope-nvim
        nvim-treesitter
        lualine-nvim
        vim-commentary
      ];
    };
  };
};

## === ZSH CONFIGURATION ===

programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  
  ohMyZsh = {
    enable = true;
    plugins = [ "git" "docker" "kubectl" "npm" "python" ];
    theme = "robbyrussell";
  };
  
  shellAliases = {
    ll = "ls -la";
    la = "ls -a";
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # Git aliases
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline";
    
    # NixOS aliases
    rebuild = "sudo nixos-rebuild switch";
    rebuild-test = "sudo nixos-rebuild test";
    nixconf = "sudo nvim /etc/nixos/configuration.nix";
    
    # Docker aliases
    dps = "docker ps";
    dpsa = "docker ps -a";
    di = "docker images";
    
    # System aliases
    update = "sudo nixos-rebuild switch --upgrade";
    cleanup = "sudo nix-collect-garbage -d";
  };
};

## === GIT CONFIGURATION ===

programs.git = {
  enable = true;
  userName = "Ashish Birajdar";
  userEmail = "your.email@example.com";
  
  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = false;
    core.editor = "nvim";
    
    # Better diffs
    diff.algorithm = "histogram";
    
    # Aliases
    alias = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "log --graph --oneline --all";
    };
  };
};

## === DIRENV (Project-specific environments) ===

programs.direnv = {
  enable = true;
  enableZshIntegration = true;
  nix-direnv.enable = true;
};

## === VIRTUALIZATION ===

# QEMU/KVM for VMs
virtualisation.libvirtd.enable = true;
users.users.ashdev.extraGroups = [ "libvirtd" ];
environment.systemPackages = with pkgs; [
  virt-manager
  qemu
  OVMF
];

## === GAMING (Optional) ===

# Steam
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
};

# Gaming libraries
hardware.graphics.enable32Bit = true;
environment.systemPackages = with pkgs; [
  lutris
  wine
  winetricks
];

## === FONTS FOR DEVELOPMENT ===

fonts.packages = with pkgs; [
  # Coding fonts
  jetbrains-mono
  fira-code
  fira-code-symbols
  source-code-pro
  hack-font
  
  # Icon fonts
  font-awesome
  material-design-icons
  
  # Nerd fonts (includes icons)
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "FiraCode"
      "Hack"
      "SourceCodePro"
      "Meslo"
    ];
  })
];

## === EXAMPLE: Full Development Setup ===

# Here's a complete example for a full-stack developer:

environment.systemPackages = with pkgs; [
  # Languages
  nodejs_20
  python311
  go
  rustc
  cargo
  
  # Tools
  vscode
  docker-compose
  kubectl
  terraform
  
  # Databases
  postgresql
  redis
  
  # CLI tools
  fzf
  ripgrep
  bat
  httpie
  jq
  yq
  
  # Git
  git
  gh
  lazygit
];

virtualisation.docker.enable = true;
programs.zsh.enable = true;
programs.neovim.enable = true;

## === NOTES ===

# 1. Don't add everything at once - start small and add as needed
# 2. After editing configuration.nix, run: sudo nixos-rebuild switch
# 3. For project-specific dependencies, use nix-shell or direnv
# 4. Check https://search.nixos.org/ for package names
# 5. Always test in VM before deploying to laptop

# Example nix-shell for a project:
# Create shell.nix in your project:
# { pkgs ? import <nixpkgs> {} }:
# pkgs.mkShell {
#   buildInputs = with pkgs; [
#     nodejs
#     yarn
#     postgresql
#   ];
# }
# Then run: nix-shell

## === PRODUCTIVITY TOOLS ===

environment.systemPackages = with pkgs; [
  # Note-taking
  obsidian
  notion-app-enhanced
  
  # Communication
  discord
  slack
  telegram-desktop
  
  # Office
  libreoffice-fresh
  
  # Media
  vlc
  mpv
  spotify
  
  # Design
  gimp
  inkscape
  krita
  
  # Screenshot tools (already included)
  flameshot
  
  # Screen recording
  obs-studio
  peek  # Simple GIF recorder
];

## === BROWSER EXTENSIONS & SETTINGS ===

# Firefox
programs.firefox = {
  enable = true;
  preferences = {
    "browser.startup.homepage" = "https://nixos.org";
    "privacy.trackingprotection.enabled" = true;
    "dom.security.https_only_mode" = true;
  };
};

## === HOW TO USE THIS FILE ===

# 1. Copy sections you need to /etc/nixos/configuration.nix
# 2. Uncomment the packages/settings you want
# 3. Run: sudo nixos-rebuild switch
# 4. Test your changes

# Example workflow:
# 1. Decide you need Python development
# 2. Copy the Python section to configuration.nix
# 3. Rebuild system
# 4. Start coding!

## === MAINTENANCE TIPS ===

# Keep your system updated:
# sudo nixos-rebuild switch --upgrade

# Clean up old generations (saves space):
# sudo nix-collect-garbage -d

# List what packages are installed:
# nix-env -qa

# Search for a package:
# nix search nixpkgs <package-name>

# Or online: https://search.nixos.org/

## === LEARNING RESOURCES ===

# - NixOS Manual: https://nixos.org/manual/nixos/stable/
# - Package Search: https://search.nixos.org/
# - Nix Pills: https://nixos.org/guides/nix-pills/
# - Awesome NixOS: https://github.com/nix-community/awesome-nix
