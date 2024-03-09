{
  config,
  lib,
  ...
}: {
  options.services.media.radarr.enable = lib.mkEnableOption "Radarr" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.radarr.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/radarr 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/radarr4k 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/radarr4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/radarrextra 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      # HD
      radarr = {
        service = {
          image = "ghcr.io/hotio/radarr:release";
          container_name = "radarr";
          depends_on = [{ name = "rclone"; condition = "service_healthy"; }];
          ports = [ "9003:7878" ];
          volumes = [
            "/mnt:/mnt"
            "/etc/media/radarr:/config"
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
      radarr4k = {
        service = {
          image = "ghcr.io/hotio/radarr:release";
          container_name = "radarr4k";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "radarr"
          ];
          ports = [ "9103:7878" ];
          volumes = [
            "/mnt:/mnt"
            "/etc/media/radarr4k:/config"
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
      radarr4kdv = {
        service = {
          image = "ghcr.io/hotio/radarr:release";
          container_name = "radarr4kdv";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "radarr"
          ];
          ports = [ "9203:7878" ];
          volumes = [
            "/mnt:/mnt"
            "/etc/media/radarr4kdv:/config"
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
      radarrextra = {
        service = {
          image = "ghcr.io/hotio/radarr:release";
          container_name = "radarrextra";
          depends_on = [
            { name = "rclone"; condition = "service_healthy"; }
            "radarr"
          ];
          ports = [ "9303:7878" ];
          volumes = [
            "/mnt:/mnt"
            "/etc/media/radarrextra:/config"
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
