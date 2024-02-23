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
      package = inputs.conduit.packages.${pkgs.system}.default;
      enable = true;
      settings.global = {
        server_name = "itsnebula.net";
        # allow_registration = true;
        database_backend = "rocksdb";
      };
    };

    networking.firewall.allowedTCPPorts = [80 443 8448];

    services.caddy = {
      enable = true;
      virtualHosts."matrix.itsnebula.net".extraConfig = ''
        reverse_proxy /_matrix/* [${osConfig.services.matrix-conduit.settings.global.address}]:${toString osConfig.services.matrix-conduit.settings.global.port}
      '';
    };
  };
}