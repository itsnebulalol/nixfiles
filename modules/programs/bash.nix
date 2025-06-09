{
  pkgs,
  lib,
  config,
  ...
}: {
  options.rebuildCommand = lib.mkOption {
    default = "nh os switch";
    type = lib.types.str;
  };

  config = {
    hm = {
      programs.bash = {
        enable = true;

        shellAliases = {
          cat = "${pkgs.bat}/bin/bat --color=always --style plain";
          grep = "grep --color";
          download = "aria2c -x16 -s16 -j16";
          ls = "eza -aF";
          la = "eza -laF";
          nswitch = config.rebuildCommand;
        };
      };

      programs.eza = {
        enable = true;
        icons = "auto";
        git = true;
        enableBashIntegration = false;
      };
    };
  };
}
