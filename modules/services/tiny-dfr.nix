{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.tiny-dfr.enable = lib.mkEnableOption "tiny-dfr";

  config.os = lib.mkIf config.services.tiny-dfr.enable {
    systemd.services.tiny-dfr = {
      description = "Tiny Apple silicon touch bar daemon";
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
        "systemd-logind.service"
      ];
      startLimitIntervalSec = 30;
      startLimitBurst = 2;

      serviceConfig = {
        Restart = "always";
        ExecStart = "${inputs.tiny-dfr.defaultPackage.${pkgs.system}}/bin/tiny-dfr";
      };
    };

    environment.etc."tiny-dfr" = {
      mode = "symlink";
      source = "${inputs.tiny-dfr}/share/tiny-dfr";
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="backlight", KERNEL=="228200000.display-pipe.0", DRIVERS=="panel-summit", ENV{SYSTEMD_READY}="0"

      SUBSYSTEM=="drm", KERNEL=="card*", DRIVERS=="adp", TAG-="master-of-seat", ENV{ID_SEAT}="seat-touchbar"

      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", ENV{ID_SEAT}="seat-touchbar"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", ENV{ID_SEAT}="seat-touchbar"

      SUBSYSTEM=="input", ATTR{name}=="MacBookPro17,1 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
      SUBSYSTEM=="input", ATTR{name}=="Mac14,7 Touch Bar", TAG+="systemd", ENV{SYSTEMD_WANTS}="tiny-dfr.service"
    '';

    boot.kernelPatches = [
      {
        name = "touch";
        patch = null;
        extraConfig = ''
          INPUT_TOUCHSCREEN y
        '';
      }
    ];
  };
}
