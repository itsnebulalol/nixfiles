{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.services.static.enable = lib.mkEnableOption "Static";

  config.os = lib.mkIf config.services.static.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        ":7697".extraConfig = ''
          root * /data/Static
          file_server browse
        '';
      };
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "4978c8b8-c9fe-47b9-af50-d59921ebdde1" = {
          credentialsFile = osConfig.age.secrets.cloudflared-home.path;
          ingress = {
            "f.itsnebula.net" = "http://127.0.0.1:7697";
          };
          default = "http_status:404";
        };
      };
    };
  };
}

