{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  options.services.media.zurg.enable = lib.mkEnableOption "Zurg" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.zurg.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/zurg 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/rclone 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/gluetun 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/gluetun/wireguard 0770 nebula ${config.services.media.group.name} -"
    ];

    environment.etc."media/zurg/config.yml".source = osConfig.age.secrets.rd_conf.path;
    environment.etc."media/rclone/rclone.conf".source = ./rclone.conf;
    environment.etc."media/gluetun/wireguard/wg0.conf" = {
      source = osConfig.age.secrets.wg-home.path;
      mode = "0770";
      uid = 1000;
      gid = 1337;
    };

    virtualisation.arion.projects.media.settings.services = {
      gluetun.service = {
        image = "docker.io/qmcgaw/gluetun:v3.38.0";
        container_name = "gluetun";
        ports = [ "9999:9999" ];
        capabilities = {
          NET_ADMIN = true;
        };
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        volumes = [
          "/etc/media/gluetun:/gluetun"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";

          VPN_SERVICE_PROVIDER = "custom";
          VPN_TYPE = "wireguard";

          HEALTH_SERVER_ADDRESS = "127.0.0.1:9998";
        };
        restart = "unless-stopped";
      };

      zurg.service = {
        image = "ghcr.io/debridmediamanager/zurg-testing:v0.9.3-hotfix.11";
        container_name = "zurg";
        depends_on = ["gluetun"];
        network_mode = "container:gluetun";
        healthcheck.test = ["CMD" "curl" "-f" "localhost:9999/dav/version.txt" "||" "exit 1"];
        volumes = [
          "/etc/media/zurg/config.yml:/app/config.yml"
          "/etc/media/zurg/data:/app/data"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
        };
        restart = "unless-stopped";
      };

      rclone.service = {
        image = "docker.io/rclone/rclone:latest";
        container_name = "rclone";
        depends_on = ["zurg"];
        healthcheck = {
          test = [ "CMD" "rclone" "lsd" "zurg:" ];
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
          PGID = "1337";
        };
        command = [ "mount" "zurg:" "/data" "--allow-non-empty" "--allow-other" "--uid=1000" "--gid=1337" "--dir-cache-time" "10s" ];
        restart = "unless-stopped";
      };
    };
  };
}
