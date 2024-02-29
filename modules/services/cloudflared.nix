{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.cloudflared.enable = lib.mkEnableOption "cloudflared";

  config.os = lib.mkIf config.services.cloudflared.enable {
    services.cloudflared = {
      enable = true;

      tunnels = {
        "4978c8b8-c9fe-47b9-af50-d59921ebdde1" = {
          credentialsFile = osConfig.age.secrets.cloudflared.path;
          ingress = {
            "f.itsnebula.net" = "http://server.coin-gray.ts.net:5381";
            "ig.itsnebula.net" = "http://server.coin-gray.ts.net:2741";
            "nostr.itsnebula.net" = "http://127.0.0.1:4629";
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
