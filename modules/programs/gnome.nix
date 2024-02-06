{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.gnome.enable = lib.mkEnableOption "Gnome";

  cfg = lib.mkIf options.programs.gnome.enable config.users;

  os.services.xserver = lib.mkIf options.programs.gnome.enable {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  os.services.gnome.games.enable = lib.mkIf options.programs.gnome.enable false;

  # Systray
  os.environment.systemPackages = lib.mkIf options.programs.gnome.enable
    [ pkgs.gnomeExtensions.appindicator ];
  os.services.udev.packages = lib.mkIf options.programs.gnome.enable
    [ pkgs.gnome.gnome-settings-daemon ];

  # Dark Mode
  hm.users.${cfg.main} = lib.mkIf options.programs.gnome.enable {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };

  # Dynamic triple buffering
  nixpkgs.overlays = lib.mkIf options.programs.gnome.enable [
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
