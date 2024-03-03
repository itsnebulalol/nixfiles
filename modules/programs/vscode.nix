{
  pkgs,
  lib,
  config,
  hmConfig,
  ...
}: {
  options.programs.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config.hm = lib.mkIf config.programs.vscode.enable {
    home = {
      packages = [pkgs.vscode pkgs.wakatime];

      file.".wakatime.cfg".source = hmConfig.age.secrets.wakatime.path;
    };
  };
}
