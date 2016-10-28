# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];

  boot.initrd.availableKernelModules = ["virtio_net" "virtio_pci" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" "ata_piix" "virtio_pci" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4ac71011-99dd-406f-abf4-40e871bf27ce";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/132a16cf-e17d-4755-89a3-6b0b4815733f";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/04b965f9-1902-45a7-9d20-21d34458d01c"; }
    ];

  nix.maxJobs = 1;
}