# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
nurpkgs = import (builtins.fetchTarball {
   url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
}) { inherit pkgs; };

in{

#nixpkgs.overlays = [nurpkgs.overlay];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };


  imports = 
  [
    (import "${home-manager}/nixos")
      ./hardware-configuration.nix
  ];
  users.users.istipisti113 = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager" "bluetooth"];
  };
  home-manager.backupFileExtension = "backup";
  #home-manager.users.istipisti113 = import /home/istipisti113/.config/home-manager/home.nix;
#}
#{
  #imports =
   # [ # Include the results of the hardware scan.
    #];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.istipisti113 = {
#    isNormalUser = true;
#    description = "Szabo Istvan";
#    extraGroups = [ "networkmanager" "wheel" ];
#    packages = with pkgs; [
#      zsh
#    ];
#    shell = pkgs.zsh;
#  };
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  neovim
  alacritty
  waybar
  wofi
  firefox
  hyprpaper
  hyprland
  sway
  tidal-hifi
  transmission-qt
  vlc
  obsidian
  jq
  cargo
  steam
  prusa-slicer
  curl
  unzip
  zip
  android-studio
  wine
  lshw
  gcc
  clang
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };


  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  services.udev.packages = with pkgs; [via oversteer];
  hardware.bluetooth.enable = true;
  hardware.keyboard.qmk.enable = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  #hardware.nvidia.open = true;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  #services.xserver.videoDrivers = [ "nvidia" ]; 
  services.blueman.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
    
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  specialisation = {
  on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce true;
      prime.offload.enableOffloadCmd = lib.mkForce true;
      prime.sync.enable = lib.mkForce false;
    };
  };
};
}
