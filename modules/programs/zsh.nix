{
  pkgs,
  lib,
  config,
  hmConfig,
  ...
}: {
  options.rebuildCommand = lib.mkOption {
    default = "nh os switch $argv";
    type = lib.types.str;
  };

  config = {
    os = {
      programs.zsh.enable = true;
    };

    hm = {
      programs.zsh = {
        enable = true;

        shellAliases = {
          cat = "${pkgs.bat}/bin/bat";
          grep = "grep --color";
          download = "aria2c -x16 -s16 -j16";
        };

        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
          ];
        };
      };

      programs.eza = {
        enable = true;
        enableAliases = false;
        icons = true;
        git = true;
      };
    };
  };
}
