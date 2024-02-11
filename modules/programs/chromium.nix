{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.chromium.enable = lib.mkEnableOption "Chromium";

  config.os = lib.mkIf config.programs.chromium.enable {
    programs.chromium.enable = true;
    programs.chromium.extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "gejiddohjgogedgjnonbofjigllpkmbf" # 1Password Nightly
    ];
  };
}
