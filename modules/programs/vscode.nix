{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config.hm = lib.mkIf config.programs.vscode.enable {
    home.packages = [pkgs.vscode];
  };
}
