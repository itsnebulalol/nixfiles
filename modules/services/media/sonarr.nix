{
  config,
  lib,
  ...
}: {
  options.services.media.sonarr.enable = lib.mkEnableOption "Sonarr" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.sonarr.enable) {
    systemd.tmpfiles.rules = [
      "d /opt/media/sonarr 0770 nebula ${config.services.media.group.name} -"
      "d /opt/media/sonarr4k 0770 nebula ${config.services.media.group.name} -"
      "d /opt/media/sonarr4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /opt/media/sonarrextra 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      # HD
      sonarr = {
        service = {
          image = "ghcr.io/hotio/sonarr:release";
          container_name = "sonarr";
          depends_on = [{ name = "rclone"; condition = "service_healthy"; }];
          ports = [ "9004:8989" ];
          volumes = [
            "/mnt:/mnt"
            "/opt/media/sonarr:/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          restart = "unless-stopped";
        };
      };

      # 4K
      sonarr4k = {
        service = {
          image = "ghcr.io/hotio/sonarr:release";
          container_name = "sonarr4k";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "sonarr"
          ];
          ports = [ "9104:8989" ];
          volumes = [
            "/mnt:/mnt"
            "/opt/media/sonarr4k:/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          restart = "unless-stopped";
        };
      };

      # 4K DV
      sonarr4kdv = {
        service = {
          image = "ghcr.io/hotio/sonarr:release";
          container_name = "sonarr4kdv";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "sonarr"
          ];
          ports = [ "9204:8989" ];
          volumes = [
            "/mnt:/mnt"
            "/opt/media/sonarr4kdv:/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          restart = "unless-stopped";
        };
      };

      # Extra
      sonarrextra = {
        service = {
          image = "ghcr.io/hotio/sonarr:release";
          container_name = "sonarrextra";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "sonarr"
          ];
          ports = [ "9304:8989" ];
          volumes = [
            "/mnt:/mnt"
            "/opt/media/sonarrextra:/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          restart = "unless-stopped";
        };
      };
    };
  };
}
