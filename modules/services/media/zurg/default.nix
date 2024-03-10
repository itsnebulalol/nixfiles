{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.media.zurg.enable = lib.mkEnableOption "Zurg" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.zurg.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/zurg 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/rclone 0770 nebula ${config.services.media.group.name} -"
    ];

    environment.etc."media/zurg/config.yml".source = pkgs.subsitituteAll ({ src = ./config.yml; rdApi = builtins.readFile osConfig.age.secrets.rd_token.path; });
    environment.etc."media/rclone/rclone.conf".source = ./rclone.conf;

    virtualisation.arion.projects.media.settings.services = {
      zurg = {
        service = {
          image = "ghcr.io/debridmediamanager/zurg-testing:v0.9.3-hotfix.11";
          container_name = "zurg";
          healthcheck.test = "curl -f localhost:9999/dav/version.txt || exit 1";
          ports = [ "9999:9999" ];
          volumes = [
            "/etc/media/zurg/config.yml:/app/config.yml"
            "/etc/media/zurg/data:/app/data"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          restart = "unless-stopped";
        };
      };

      rclone = {
        service = {
          image = "docker.io/rclone/rclone:latest";
          container_name = "rclone";
          depends_on = [{ name = "zurg"; condition = "service_healthy"; }];
          healthcheck = {
            test = "rclone lsd zurg:";
            interval = "5s";
            timeout = "5s";
            retries = 12;
            start_period = "5s";
          };
          capabilities = {
            SYS_ADMIN = true;
          };
          devices = [ "/dev/fuse:/dev/fuse:rwm" ];
          volumes = [
            "/mnt/remote/realdebrid:/data:rshared"
            "/etc/media/rclone/rclone.conf:/config/rclone/rclone.conf"
            "/mnt:/mnt"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "${config.services.media.group.gid}";
          };
          command = "mount zurg: /data --allow-non-empty --allow-other --uid=1000 --gid=${config.services.media.group.gid} --dir-cache-time 10s";
          restart = "unless-stopped";
        };
      };
    };
  };
}
