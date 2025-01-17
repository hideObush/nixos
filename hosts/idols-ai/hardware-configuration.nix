# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];
  boot.initrd = {
    luks.devices."crypted-nixos" = {
      device = "/dev/disk/by-uuid/f77d55ae-e377-4616-a0cb-73d476740e21";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["relatime" "mode=755"];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@persistent" "compress-force=zstd:1"];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@nix" "noatime" "compress-force=zstd:1"];
  };

  fileSystems."/btr_pool" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvolid=5"];
  };

  fileSystems."/gnu" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@guix" "compress-force=zstd:1"];
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress-force=zstd:1"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@swap"];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/b5af052e-0d52-40f7-9126-dabc0b70a338";
    fsType = "btrfs";
    options = ["subvol=@tmp" "compress-force=zstd:1"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/593D-C372";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
