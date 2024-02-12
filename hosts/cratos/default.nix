{
  lib,
  inputs,
  pkgs,
  ...
}: {
  osModules = [./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.loader.grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
    };

    networking = {
      hostName = "cratos";
      networkmanager.enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    services.avahi.enable = true;

    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    users.users = let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv"
      ];
    in {
      nebula.openssh.authorizedKeys.keys = keys;
      root.openssh.authorizedKeys.keys = keys;
    };

    time.timeZone = "America/New_York";
    time.hardwareClockInLocalTime = true;

    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}
