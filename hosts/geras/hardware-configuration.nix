{ lib, ... }: {
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["noatime" "discard"];
  };

  fileSystems."/data" = {
    device = "/dev/sdb";
    fsType = "xfs";
    options = ["uid=${toString osConfig.users.users.nebula.uid}" "gid=${toString osConfig.users.users.nebula.uid}"];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
