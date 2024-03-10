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
    ];

    virtualisation.arion.projects.media.settings.services = {
      # HD
      sonarr = {
        service = {
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
      };

      # 4K
      sonarr4k = {
        service = {
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
      };

      # 4K DV
      sonarr4kdv = {
        service = {
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
      };

      # Extra
      sonarrextra = {
        service = {
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
    };
  };
}
