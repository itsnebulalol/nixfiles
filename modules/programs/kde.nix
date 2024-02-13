{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.kde.enable = lib.mkEnableOption "KDE";

  config = lib.mkMerge [
    (lib.mkIf config.programs.kde.enable {
      os = {
        services = {
          xserver = {
            enable = true;
            desktopManager.plasma5.enable = true;
            displayManager.sddm.enable = true;
            displayManager.defaultSession = "plasmawayland";
          };
        };
      };

      hm = {
        dconf = {
          enable = true;
        };

        gtk = {
          enable = true;
          theme = {
            name = "Rose-Pine";
            package = pkgs.rose-pine-gtk-theme;
          };
        };
      };
    })
  ];
}
