{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.chromium.enable = lib.mkEnableOption "Chromium";

  config.hm = lib.mkIf config.programs.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium;
      extensions = [
        # uBlock Origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        # 1Password Nightly
        { id = "gejiddohjgogedgjnonbofjigllpkmbf"; }
      ];
    };
  };
}
