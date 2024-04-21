{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  options.services.conduit.enable = lib.mkEnableOption "conduit";

  config.os = lib.mkIf config.services.conduit.enable {
    services.matrix-conduit = {
      package = inputs.conduwuit.packages.${pkgs.system}.default;
      enable = true;
      settings.global = {
        address = "0.0.0.0";
        server_name = "itsnebula.net";
        database_backend = "rocksdb";
      };
    };
  };
}
