{
  lib,
  inputs,
  pkgs,
  ...
}: {
  osModules = [inputs.apple-silicon-support.nixosModules.apple-silicon-support ./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    networking = {
      hostName = "arete";
      wireless = {
        enable = false;
        iwd.enable = true;
      };
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # AirPlay support
    services.avahi.enable = true;

    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = lib.mkForce false;
    };

    users.users = let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv" # main SSH key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVho+KHY8MayDm1un32hZUZt6H4SsMTboEwvQzYuf5E" # semreh
      ];
    in {
      nebula.openssh.authorizedKeys.keys = keys;
      root.openssh.authorizedKeys.keys = keys;
    };

    time.timeZone = "America/New_York";

    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}
