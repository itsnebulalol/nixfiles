{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.services.monero.enable = lib.mkEnableOption "monero";

  config.os = lib.mkIf config.services.monero.enable {
    environment.systemPackages = [ pkgs.monero ];

    services.monero = {
      enable = true;
      dataDir = "/data/monero";
    }
  };
}
