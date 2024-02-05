{
  pkgs,
  lib,
  config,
  ...
}: {
  os.services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  os.services.gnome.games.enable = false;
}
