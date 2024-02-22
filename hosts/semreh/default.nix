{
  lib,
  inputs,
  pkgs,
  ...
}: {
  osModules = [inputs.nixos-hardware.nixosModules.raspberry-pi-4 ./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    boot.loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    networking = {
      hostName = "semreh";
      networkmanager.enable = true;
    };

    console.enable = false;

    systemd.services.NetworkManager-wait-online.enable = false;

    services.avahi.enable = true;

    users.users = let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv"
      ];
    in {
      nebula.openssh.authorizedKeys.keys = keys;
      root.openssh.authorizedKeys.keys = keys;
    };

    time.timeZone = "America/New_York";

    hardware.enableRedistributableFirmware = true;
    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}