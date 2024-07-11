{
  config,
  lib,
  ...
}: {
  options.services.media.rdtclient.enable = lib.mkEnableOption "RDTClient";

  config.os = lib.mkIf (config.services.media.enable && config.services.media.rdtclient.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/rdtclient 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      rdtclient.service = {
        image = "docker.io/itsnebulalol/rdtclient:master";
        container_name = "rdtclient";
        depends_on = ["rclone"];
        ports = [ "9001:6500" ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/mnt:/mnt"
          "/etc/media/rdtclient/data:/data"
          "/etc/media/rdtclient/data/db:/data/db"
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
        "rdtclient.m.svrd.me".extraConfig = ''
          reverse_proxy 127.0.0.1:9001
          import cloudflare
        '';
      };
    };
  };
}
