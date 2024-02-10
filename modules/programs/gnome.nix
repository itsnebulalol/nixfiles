{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.gnome.enable = lib.mkEnableOption "Gnome";

  config = lib.mkMerge [
    (lib.mkIf config.programs.gnome.enable {
      os = {
        services = {
          xserver = {
            enable = true;
            desktopManager.gnome.enable = true;
            displayManager.gdm.enable = true;
          };
          gnome.games.enable = false;

          udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
        };

        programs.gnome-terminal.enable = true;

        environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];

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
      };

      # Dconf
      hm.dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        settings."org/gnome/shell".favorite-apps = [
          "chromium-browser.desktop"
          "org.Gnome.Nautilus.desktop"
          "vesktop.desktop"
          "org.gnome.Console.desktop"
          "1password.desktop"
          "code.desktop"
        ];
        settings."org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];
        settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
        settings."org/gnome/settings-daemon.plugins.power" = {
          idle-dim = false;
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
        settings."org/gtk/gtk4/settings/file-chooser".show-hidden = true;
        settings."org/gnome/desktop/interface".scaling-factor = 175;
      };
    })
  ];
}
