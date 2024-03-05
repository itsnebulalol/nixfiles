_: {
  osModules = [./hardware-configuration.nix];

  os = {
    nixpkgs.config.allowUnfree = true;

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = {
      hostName = "maniae";
      networkmanager.enable = true;

      interfaces.eth0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "10.0.0.18";
          prefixLength = 24;
        }];
      };

      defaultGateway = "10.0.0.1";
      nameservers = ["1.1.1.1" "1.0.0.1"];
    };

    console.enable = false;

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

    time.timeZone = "America/New_York";

    hardware.enableRedistributableFirmware = true;
    system.stateVersion = "23.05";
  };

  hm.home.stateVersion = "23.05";
}
