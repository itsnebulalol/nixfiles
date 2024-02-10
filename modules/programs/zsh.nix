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

      users.defaultUserShell = pkgs.zsh;
    };

    hm = {
      programs.zsh = {
        enable = true;

        shellAliases = {
          cat = "${pkgs.bat}/bin/bat --color=always --style plain";
          grep = "grep --color";
          download = "aria2c -x16 -s16 -j16";
          ls = "eza -aF";
          la = "eza -laF";
        };

        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
            { name = "spaceship-prompt/spaceship-prompt"; tags = [ use:spaceship.zsh from:github as:theme ]; }
          ];
        };
      };

      programs.eza = {
        enable = true;
        enableAliases = false;
        icons = true;
        git = true;
      };

      programs.direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv.override {
            nix = pkgs.nix-super;
          };
        };
      };
    };
  };
}
