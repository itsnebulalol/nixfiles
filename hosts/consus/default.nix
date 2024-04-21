{
  osConfig,
  ...
}: {
  osModules = [./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.loader.grub = {
      enable = true;
      device = "/dev/sdb";
      useOSProber = true;
    };

    networking = {
      hostName = "consus";
      networkmanager.enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    services.avahi.enable = true;

    users.users = let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv" # main SSH key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPQbrPo6LqXSvUYbHTVPymkWhhb4jhlBSjIUYs4JMHL" # arete key
      ];
    in {
      nebula.openssh.authorizedKeys.keys = keys;
      root.openssh.authorizedKeys.keys = keys;
    };

    #fileSystems."/data" = {
    #  device = "/dev/disk/by-label/data";
    #  fsType = "ext4";
    #  options = ["uid=1000" "gid=100"];
    #};

    time.timeZone = "America/New_York";

    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}
