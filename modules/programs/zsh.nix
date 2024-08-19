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
    os = {
      programs.zsh.enable = true;

      environment.localBinInPath = true;

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
          nswitch = config.rebuildCommand;
          nupdate = "cd $FLAKE && git pull && nix flake update && ${config.rebuildCommand} && cd -";
        };

        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
            # { name = "spaceship-prompt/spaceship-prompt"; tags = [ use:spaceship.zsh from:github as:theme ]; }
            { name = "chisui/zsh-nix-shell"; tags = [ use:nix-shell.plugin.zsh from:github ]; }
          ];
        };
      };

      #programs.starship = {
      #  enable = true;
      #  enableZshIntegration = true;
      #};

      programs.eza = {
        enable = true;
        icons = true;
        git = true;
        enableZshIntegration = false;
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
