{
  osConfig,
  ...
}: {
  osModules = [./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = {
      hostName = "geras";
      networkmanager.enable = true;

      interfaces.end0.ipv4.addresses = [{
        address = "192.168.1.195";
        prefixLength = 24;
      }];

      defaultGateway = "192.168.1.1";
      nameservers = [ "192.168.1.242" "192.168.1.221" ];
    };

    systemd = {
      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowSuspendThenHibernate=no
        AllowHybridSleep=no
      '';
      services.NetworkManager-wait-online.enable = false;
    };

    services = {
      avahi.enable = true;
      logind.extraConfig = ''
        LidSwitchIgnoreInhibited=no
        HandlePowerKey=ignore
        HandleLidSwitch=ignore
      '';
    };

    users.users = let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv" # main SSH key
      ];
    in {
      nebula.openssh.authorizedKeys.keys = keys;
      root.openssh.authorizedKeys.keys = keys;
    };

    fileSystems."/data" = {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
      options = ["uid=1000" "gid=100"];
    };

    time.timeZone = "America/New_York";

    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}
