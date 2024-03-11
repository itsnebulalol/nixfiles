{
  config,
  lib,
  ...
}: {
  options.services.media.prowlarr.enable = lib.mkEnableOption "Prowlarr" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.prowlarr.enable) {
    virtualisation.arion.projects.media.settings.services = {
      flaresolverr = {
        service = {
          image = "ghcr.io/flaresolverr/flaresolverr:latest";
          container_name = "flaresolverr";
          ports = [ "9009:8191" ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "1337";

            LOG_LEVEL = "info";
            LOG_HTML = "false";
            CAPTCHA_SOLVER = "none";
          };
          restart = "unless-stopped";
        };
      };

      prowlarr = {
        service = {
          image = "lscr.io/linuxserver/prowlarr:latest";
          container_name = "prowlarr";
          ports = [ "9002:9696" ];
          volumes = [
            "/etc/media/prowlarr:/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "1337";
          };
          restart = "unless-stopped";
        };
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "prowlarr.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9002
        '';
      };
    };
  };
}
