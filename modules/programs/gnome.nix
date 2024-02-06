{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.gnome.enable = lib.mkEnableOption "Gnome";

  lib.mkIf config.programs.gnome.enable {
    cfg = config.users;

    os.services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    os.services.gnome.games.enable = false;

    # Systray
    os.environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
    os.services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # Dark Mode
    hm.users.${cfg.main} = {
      dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
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
  }
}
