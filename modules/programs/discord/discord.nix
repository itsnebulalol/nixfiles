{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.discord;
  inherit (lib) mkEnableOption mkIf;
in {
  options.programs.discord = {
    enable = mkEnableOption "discord";
    package = lib.mkOption {
      default = pkgs.vesktop;
    };
    finalPackage = lib.mkOption {
      readOnly = true;
      default = cfg.package.overrideAttrs (old: {
        patches = (old.patches or []) ++ [./readonlyFix.patch];
        postFixup = ''
          wrapProgram $out/bin/${cfg.package.meta.mainProgram or (lib.getName cfg.package)} \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      });
    };
  };

  config.hm = mkIf cfg.enable {
    home.packages = [
      cfg.finalPackage
    ];

    xdg.configFile."vesktop/settings.json".source = ./vesktop.json;
    xdg.configFile."vesktop/settings/settings.json".source = ./vendetta.json;
  };
}
