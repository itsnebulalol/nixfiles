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
        "47bf6f5a-a864-4903-9a18-1045d7c8f179" = {
          credentialsFile = osConfig.age.secrets.cloudflared.path;
          ingress = {
            "f.itsnebula.net" = "http://server.coin-gray.ts.net:5381";
            "ig.itsnebula.net" = "http://server.coin-gray.ts.net:2741";

            "matrix.itsnebula.net" = {
              service = "http://127.0.0.1:${toString osConfig.services.matrix-conduit.settings.global.port}";
              path = "/_matrix";
            };
            "matrix-fed.itsnebula.net" = {
              originRequest.httpHostHeader = "matrix.itsnebula.net";
              service = "http://127.0.0.1:${toString osConfig.services.matrix-conduit.settings.global.port}";
              path = "/_matrix";
            };
          };
          default = "http_status:404";
        };
      };
    };
  };
}
