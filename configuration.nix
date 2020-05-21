# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./b123400.nix
      ./nginx.nix
      ./blog/service.nix
      ./whosetweet/service.nix
      ./krrForm/service.nix
      ./todograph/service.nix
      ./ferry-web/service.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;
  boot.cleanTmpDir = true;

  boot.kernelParams = ["console=ttyS0,19200n8"];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  networking.hostName = "Hanekawa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    wget vim
    inetutils
    mtr
    sysstat
    certbot
    (import ./vim.nix)
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
    '';
    extraStopCommands = ''
      iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
    '';
    allowedUDPPorts = [ 1194 ];
    allowedTCPPorts = [ 9091 ];
    trustedInterfaces = [ "tun0" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.interfaces= {
    eth0 = {
      tempAddress = "disabled";
    };
    tun0 = {
      tempAddress = "disabled";
    };
  };

  services.nginx.enable = true;
  services.nginx.statusPage = true;

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

  #networking.nat = {
  #  enable = true;
  #  externalInterface = "eth0";
  #  internalInterfaces = [ "wg0" ];
  #};

  #networking.usePredictableInterfaceNames = false;
  networking.enableIPv6 = true;

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    extraOptions = ''
      character-set-server    = utf8mb4
      collation-server        = utf8mb4_general_ci
    '';
  };

  services.neo4j = {
    enable = true;
    shell.enable = true;
    bolt.enable = true;
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

  services.longview = {
    enable = true;
    apiKey = (import ./secrets.nix).longview.apiKey;
    # TODO: use apiKeyFile

    nginxStatusUrl = "http://localhost/nginx_status";
    # mysqlUser = "";
    # mysqlPassword = "";
  };
  services.logind.extraConfig = "RuntimeDirectorySize=1024M";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
