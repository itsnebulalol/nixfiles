{
  config,
  lib,
  ...
}: {
  options.services.media.annatar.enable = lib.mkEnableOption "Annatar";

  config.os = lib.mkIf (config.services.media.enable && config.services.media.annatar.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/annatar 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/annatar/jackett 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/annatar/redis 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      jackett-annatar.service = {
        image = "docker.io/linuxserver/jackett";
        container_name = "jackett-annatar";
        ports = [ "9010:9117" ];
        volumes = [
          "/etc/media/annatar/jackett:/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };

      annatar.service = {
        image = "registry.gitlab.com/stremio-add-ons/annatar:latest";
        container_name = "annatar";
        ports = [ "9011:9011" ];
        volumes = [
          "/etc/media/annatar/redis:/app/data"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";

          LOG_LEVEL = "debug";
          LISTEN_PORT = "9011";
          JACKETT_URL = "http://jackett-annatar:9117";
          JACKETT_MAX_RESULTS = "100";
          JACKETT_TIMEOUT = "60";
          JACKETT_INDEXERS = "yts,eztv,kickasstorrents-ws,thepiratebay,therarbg,torrentgalaxy,bitsearch,limetorrents,badasstorrents";
          JACKETT_API_KEY = "ny8t8735sar5vjlucpkf42km1qadsd0o";
        };
        restart = "unless-stopped";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "annatar.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9011
          import cloudflare
        '';
      };
    };
  };
}
