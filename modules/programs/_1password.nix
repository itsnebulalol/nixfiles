{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs._1password.enable = lib.mkEnableOption "1Password";

  config.hm = lib.mkIf config.programs._1password.enable {
    home.packages = [pkgs._1password pkgs._1password-gui];
  };
}
