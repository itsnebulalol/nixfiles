{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.chromium.enable = lib.mkEnableOption "Chromium";

  config.hm = lib.mkIf config.programs.chromium.enable {
    home.packages = [pkgs.chromium];
  };
}
