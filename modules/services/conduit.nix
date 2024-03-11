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
        database_backend = "rocksdb";
      };
    };

    networking.firewall.allowedTCPPorts = [80 443 8448];

    /* services.caddy = {
      enable = true;
      virtualHosts."matrix.itsnebula.net".extraConfig = ''
        reverse_proxy /_matrix/* [${osConfig.services.matrix-conduit.settings.global.address}]:${toString osConfig.services.matrix-conduit.settings.global.port}
      '';
      virtualHosts."matrix.itsnebula.net:8448".extraConfig = ''
        reverse_proxy /_matrix/* [${osConfig.services.matrix-conduit.settings.global.address}]:${toString osConfig.services.matrix-conduit.settings.global.port}
      '';
    }; */

    services.cloudflared = {
      enable = true;
      tunnels = {
        "4978c8b8-c9fe-47b9-af50-d59921ebdde1" = {
          credentialsFile = osConfig.age.secrets.cloudflared-home.path;
          ingress = {
            "matrix.itsnebula.net" = {
              service = "http://[${osConfig.services.matrix-conduit.settings.global.address}]:${toString osConfig.services.matrix-conduit.settings.global.port}";
              path = "/_matrix";
            };
          };
          default = "http_status:404";
        };
      };
    };
  };
}
