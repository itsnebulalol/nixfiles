{
  lib,
  inputs,
  pkgs,
  ...
}: {
  osModules = [inputs.apple-silicon-support.nixosModules.apple-silicon-support ./hardware-configuration.nix];

  os = let
    box64 = pkgs.box64.overrideAttrs (old: {
      version = "unstable-2024-01-29";
      src = pkgs.fetchFromGitHub {
        owner = "ptitSeb";
        repo = "box64";
        rev = "9793c3b142c325d9405b1baa5959547a3f49fcaf";
        hash = "sha256-zvkSeZcDWj+3XJSo3c5MRk3e0FJhVe7FuEyEVwkCzPE=";
      };
      cmakeFlags = (old.cmakeFlags or []) ++ ["-D M1=1"];
    });
  in {
    nixpkgs.config.allowUnfree = true;

    boot.extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    boot.binfmt.registrations.x86_64-linux = {
      interpreter = "${lib.getExe box64}";
      preserveArgvZero = true;
      recognitionType = "magic";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };

    environment.systemPackages = [
      box64
      pkgs.pkgsCross.gnu64.gcc7
    ];

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
