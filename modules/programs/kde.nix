{
  pkgs,
  lib,
  config,
  inputs,
  hmConfig,
  ...
}: {
  options.programs.kde.enable = lib.mkEnableOption "KDE";

  config = lib.mkMerge [
    (lib.mkIf config.programs.kde.enable {
      hmModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];

      os = {
        services = {
          xserver = {
            enable = true;
            desktopManager.plasma5.enable = true;
            displayManager = {
              defaultSession = "plasmawayland";
              sddm.enable = true;
            };
          };
        };

        environment.systemPackages = [ pkgs.plasma-rose-pine ];
      };

      hm = {
        programs.plasma = {
          enable = true;

          workspace = {
            theme = "breeze-dark";
            colorScheme = "RosePineMoon";
          };

          configFile = {
            "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
            "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 100;
            "plasma-org\\.kde\\.plasma\\.desktop-appletsrc"."Containments\\.2\\.Applets\\.5\\.Configuration\\.General"."launchers" = "preferred://filemanager,preferred://browser,applications:vesktop.desktop,applications:org.kde.konsole.desktop,applications:code-url-handler.desktop";
          };
        };

        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          gtk2.configLocation = "${hmConfig.xdg.configHome}/gtk-2.0/gtkrc";
          theme = {
            name = "rose-pine";
            package = pkgs.rose-pine-gtk-theme;
          };
          iconTheme = {
            name = "rose-pine";
            package = pkgs.rose-pine-icon-theme;
          };
        };
      };
    })
  ];
}
