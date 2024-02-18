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
      ./website.nix
      ./diary.nix
      ./carlife/service.nix
      (import ./pleroma.nix {

       })
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;
  boot.tmp.cleanOnBoot = true;

  boot.kernelParams = ["console=ttyS0,19200n8"];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  networking.hostName = "Hanekawa"; # Define your hostname.
  networking.domain = "b123400.net";
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
    settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o enp0s4 -j MASQUERADE
      iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp0s4 -j MASQUERADE
    '';

    extraStopCommands = ''
      iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o enp0s4 -j MASQUERADE
      iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp0s4 -j MASQUERADE
    '';

    allowedUDPPorts = [ 1194 51820 ];
    allowedTCPPorts = [ 9091 ];
    trustedInterfaces = [ "tun0" "wg0" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;
  };

  networking.interfaces= {
    enp0s4 = {
      tempAddress = "disabled";
    };
    tun0 = {
      tempAddress = "disabled";
    };
  };

  services.nginx.enable = true;
  services.nginx.statusPage = true;

  networking.nat = {
    enable = true;
    externalInterface = "enp0s4";
    internalInterfaces = [ "wg0" ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [
        "10.100.0.1/24"
        "fd42:42:42::1/64"
      ];

      # The port that Wireguard listens to. Must be accessible by the client.
      listenPort = 51820;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/wireguard-keys/private";

      peers = [
        # List of allowed peers.
        { # BK201, Abumizaka
          publicKey = "gL8X0IGTkqDsjuaQf5pmvaTmYh6mpMF5q9VOr7/o8CU=";
          allowedIPs = [
            "10.100.0.3/32"
            "fd42:42:42::3/128"
          ];
        }
        { # Yoite
          publicKey = "QeY/PNDTjrgJTuGmgbeeX3j6X/6Wa0q5hiNXzu7jz2w=";
          allowedIPs = [
            "10.100.0.4/32"
            "fd42:42:42::4/128"
          ];
        }
        { # Macbook Air 2012
          publicKey = "q5lf+JhGvtbO9XphmM8P/DnD03urR1j39GLl7hHirDg=";
          allowedIPs = [
            "10.100.0.5/32"
            "fd42:42:42::5/128"
          ];
        }
        { # Min
          publicKey = "GMWM/NvFkFbqkZJsSCCNL4D9saELbaRGsVH41Yk4JQs=";
          allowedIPs = [
            "10.100.0.6/32"
            "fd42:42:42::6/128"
          ];
        }
        { # Heidi
          publicKey = "buONH1J2bxIjAD+6YDbNpSOaEndWAyzZZ/SWZ0jloFs=";
          allowedIPs = [
            "10.100.0.7/32"
            "fd42:42:42::7/128"
          ];
        }
        { # KC
          publicKey = "JwqCoyeRcYphiGMjzb5qVQJl7YHgsku+owfjUIPQni0=";
          allowedIPs = [
            "10.100.0.8/32"
            "fd42:42:42::8/128"
          ];
        }
        { # M1
          publicKey = "l4NPQRf3K/NYXJhvrDJiBPOgUS3bJH8KUn3tmJkmQU8=";
          allowedIPs = [
            "10.100.0.9/32"
            "fd42:42:42::9/128"
          ];
        }
      ];
    };
  };

  #networking.nameservers = [ "::1" ];
  #networking.resolvconf.enable = false;
  #services.resolved.enable = false;
  environment.etc."resolv.conf".enable = false;
    # If using dhcpcd:
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
  networking.networkmanager.dns = "none";

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      listen_addresses = [
        #"127.0.0.1:53" 
        #"10.100.0.1:53" 
        #"[fd42:42:42::1]:53"
        "0.0.0.0:53"
      ];

      static.NextDNS-26a8a1 = {
        stamp = "sdns://...";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v2/public-resolvers.md
      server_names = [ "..." ];
    };
  };

  networking.usePredictableInterfaceNames = true;
  networking.enableIPv6 = true;

  services.transmission =
    let secrets = (import ./secrets.nix).transmission;
    in {
      enable = true;
      settings = {
        rpc-bind-address = "10.100.0.1";
        rpc-enabled = true;
        rpc-whitelist-enabled = true;
        rpc-whitelist = "10.8.*.*,10.100.*.*,,10.100.0.1,127.0.0.1,192.168.*.*";
        rpc-username = secrets.username;
        rpc-password = secrets.password;
      };
    };

  services.longview = {
    enable = true;
    apiKeyFile = /home/b123400/longview_api_key;

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
