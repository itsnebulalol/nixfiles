{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.media.blackhole.enable = lib.mkEnableOption "Blackhole";

  config.os = lib.mkIf (config.services.media.enable && config.services.media.blackhole.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/blackhole 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/blackhole4k 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/blackhole4kdv 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/blackholeextra 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      blackhole.service = {
        image = "docker.io/library/blackhole";
        container_name = "blackhole";
        depends_on = ["rclone"];
        user = "1000:1337";
        volumes = [
          "/mnt:/mnt"
          "/etc/media/blackhole/logs:/app/logs"
          "/mnt/symlinks/sonarr:/app/blackhole/sonarr"
          "/mnt/symlinks/radarr:/app/blackhole/radarr"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
          BLACKHOLE_RD_MOUNT_TORRENTS_PATH = "/mnt/remote/realdebrid/torrents";
        };
        env_file = [
          osConfig.age.secrets.blackhole.path
        ];
        restart = "unless-stopped";
      };

      blackhole4k.service = {
        image = "docker.io/library/blackhole";
        container_name = "blackhole4k";
        depends_on = ["rclone"];
        user = "1000:1337";
        volumes = [
          "/mnt:/mnt"
          "/etc/media/blackhole4k/logs:/app/logs"
          "/mnt/symlinks/sonarr4k:/app/blackhole/sonarr4k"
          "/mnt/symlinks/radarr4k:/app/blackhole/radarr4k"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
          BLACKHOLE_RD_MOUNT_TORRENTS_PATH = "/mnt/remote/realdebrid/torrents";
        };
        env_file = [
          osConfig.age.secrets.blackhole4k.path
        ];
        restart = "unless-stopped";
      };

      blackhole4kdv.service = {
        image = "docker.io/library/blackhole";
        container_name = "blackhole4kdv";
        depends_on = ["rclone"];
        user = "1000:1337";
        volumes = [
          "/mnt:/mnt"
          "/etc/media/blackhole4kdv/logs:/app/logs"
          "/mnt/symlinks/sonarr4kdv:/app/blackhole/sonarr4kdv"
          "/mnt/symlinks/radarr4kdv:/app/blackhole/radarr4kdv"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
          BLACKHOLE_RD_MOUNT_TORRENTS_PATH = "/mnt/remote/realdebrid/torrents";
        };
        env_file = [
          osConfig.age.secrets.blackhole4kdv.path
        ];
        restart = "unless-stopped";
      };

      blackholeextra.service = {
        image = "docker.io/library/blackhole";
        container_name = "blackholeextra";
        depends_on = ["rclone"];
        user = "1000:1337";
        volumes = [
          "/mnt:/mnt"
          "/etc/media/blackholeextra/logs:/app/logs"
          "/mnt/symlinks/sonarrextra:/app/blackhole/sonarrextra"
          "/mnt/symlinks/radarrextra:/app/blackhole/radarrextra"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
          BLACKHOLE_RD_MOUNT_TORRENTS_PATH = "/mnt/remote/realdebrid/torrents";
        };
        env_file = [
          osConfig.age.secrets.blackholeextra.path
        ];
        restart = "unless-stopped";
      };
    };
  };
}
