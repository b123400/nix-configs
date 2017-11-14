# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
      ./b123400.nix
      ./whosetweet/service.nix
      # ./blog/service.nix
      ./blog2/service.nix
      ./nginx.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  boot.cleanTmpDir = true;

  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.extraConfig = "serial; terminal_input serial; terminal_output serial";

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.hostName = "Hanekawa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o enp0s4 -j MASQUERADE
    '';
    extraStopCommands = ''
      iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o enp0s4 -j MASQUERADE
    '';
    allowedUDPPorts = [ 1194 ];
    allowedTCPPorts = [ 9091 ];
    trustedInterfaces = [ "tun0" ];
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";



  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  #   wget
    (import ./vim.nix)
    certbot
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.nginx.enable = true;
  services.nscd.enable = false;

  services.openvpn = {
    servers = {
      nadeko = {
        config = ''
          dev tun0
          # ifconfig 10.8.0.1 10.8.0.2
          port 1194
          comp-lzo
          server 10.8.0.0 255.255.255.0

          ca /root/openvpn/pki/ca.crt
          cert /root/openvpn/pki/issued/Hanekawa.crt
          key /root/openvpn/pki/private/Hanekawa.key
          tls-auth /root/openvpn/ta.key
          dh /root/openvpn/pki/dh.pem

          push "redirect-gateway def1"
          push "dhcp-option DNS 8.8.8.8"
        '';
      };
    };
  };
  systemd.services."openvpn-for-yoite".serviceConfig.TimeoutStartSec = "6min";

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    extraOptions = ''
      character-set-server    = utf8
      collation-server        = utf8_unicode_ci
    '';
  };

  services.transmission =
    let secrets = (import ./secrets.nix).transmission;
    in {
      enable = true;
      settings = {
        rpc-enabled = true;
        rpc-whitelist-enabled = true;
        rpc-whitelist = "10.8.*.*,127.0.0.1,192.168.*.*,139.162.15.81";
        rpc-username = secrets.username;
        rpc-password = secrets.password;
      };
    };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
