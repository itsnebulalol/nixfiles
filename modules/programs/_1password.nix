{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs._1password.enable = lib.mkEnableOption "1Password";

  config.os = lib.mkIf config.programs._1password.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "nebula" ];
    };
  };
}
