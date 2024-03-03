{ lib, ... }: {
  boot.initrd.availableKernelModules = ["usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["usbhid" "dm-snapshot"];
  boot.kernelModules = [ "apple_z2" ];
  boot.extraModulePackages = [ ];

  services.upower.enable = true;

  boot.initrd.luks.devices = {
    nixos-enc = {
      device = "/dev/nvme0n1p5";
      preLVM = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["noatime" "discard"];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  hardware.asahi = {
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = ./firmware;
    withRust = true;
    useExperimentalGPUDriver = true;
    # experimentalGPUInstallMode = "overlay";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
