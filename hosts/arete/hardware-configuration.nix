{
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/890f2023-dc4e-4e0d-9af4-c80cca29385c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B7F5-191C";
    fsType = "vfat";
    options = ["noatime" "discard"];
  };

  swapDevices = [ ];

  hardware.asahi = {
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = ./firmware;
    withRust = true;
    addEdgeKernelConfig = true;
    useExperimentalGPUDriver = true;
    # experimentalGPUInstallMode = "overlay";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
