{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.gnome.enable = lib.mkEnableOption "Gnome";

  config = lib.mkMerge [
    (lib.mkIf config.programs.gnome.enable {
      os.services.xserver = {
        enable = true;
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };
      os.services.gnome.games.enable = false;

      # Systray
      os.environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
      os.services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];

      # Dconf
      hm.users.nebula = {
        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
          settings."org/gnome/shell".favorite-apps = [
            "chromium-desktop.desktop"
            "org.Gnome.Nautilus.desktop"
            "vesktop.desktop"
            "org.gnome.Console.desktop"
            "1password.desktop"
            "code.desktop"
          ];
        };
      };

      # Dynamic triple buffering
      nixpkgs.overlays = [
        (final: prev: {
          gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
            mutter = gnomePrev.mutter.overrideAttrs ( old: {
              src = pkgs.fetchgit {
                url = "https://gitlab.gnome.org/vanvugt/mutter.git";
                # GNOME 45: triple-buffering-v4-45
                rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
                sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
              };
            } );
          });
        })
      ];
    })
  ];
}
