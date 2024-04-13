{
  config,
  lib,
  ...
}: {
  options.services.media.sonarr.enable = lib.mkEnableOption "Sonarr" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.sonarr.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/sonarr 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/sonarr4k 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/sonarr4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/sonarrextra 0770 nebula ${config.services.media.group.name} -"

      "d /mnt/symlinks/sonarr 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/symlinks/sonarr4k 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/symlinks/sonarr4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/symlinks/sonarrextra 0770 nebula ${config.services.media.group.name} -"

      "d /mnt/libraries/tv 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/libraries/tv4k 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/libraries/tv4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /mnt/libraries/tvextra 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      # HD
      sonarr.service = {
        image = "ghcr.io/hotio/sonarr:release";
        container_name = "sonarr";
        depends_on = ["rclone"];
        ports = [ "9004:8989" ];
        volumes = [
          "/mnt:/mnt"
          "/etc/media/sonarr:/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };

      # 4K
      sonarr4k.service = {
        image = "ghcr.io/hotio/sonarr:release";
        container_name = "sonarr4k";
        depends_on = [
          "rclone"
          "sonarr"
        ];
        ports = [ "9104:8989" ];
        volumes = [
          "/mnt:/mnt"
          "/etc/media/sonarr4k:/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };

      # 4K DV
      sonarr4kdv.service = {
        image = "ghcr.io/hotio/sonarr:release";
        container_name = "sonarr4kdv";
        depends_on = [
          "rclone"
          "sonarr"
        ];
        ports = [ "9204:8989" ];
        volumes = [
          "/mnt:/mnt"
          "/etc/media/sonarr4kdv:/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };

      # Extra
      sonarrextra.service = {
        image = "ghcr.io/hotio/sonarr:release";
        container_name = "sonarrextra";
        depends_on = [
          "rclone"
          "sonarr"
        ];
        ports = [ "9304:8989" ];
        volumes = [
          "/mnt:/mnt"
          "/etc/media/sonarrextra:/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "sonarr.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9004
          import cloudflare
        '';

        "sonarr4k.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9104
          import cloudflare
        '';

        "sonarr4kdv.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9204
          import cloudflare
        '';

        "sonarrextra.ms.itsnebula.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9304
          import cloudflare
        '';
      };
    };
  };
}
