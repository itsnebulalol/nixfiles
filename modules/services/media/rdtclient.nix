{
  config,
  lib,
  ...
}: {
  options.services.media.rdtclient.enable = lib.mkEnableOption "RDTClient" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.rdtclient.enable) {
    systemd.tmpfiles.rules = [
      "d /opt/media/rdtclient 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      rdtclient = {
        service = {
          image = "ghcr.io/itsnebulalol/rdtclient:master";
          container_name = "rdtclient";
          depends_on = [{ name = "rclone"; condition = "service_healthy"; }];
          ports = [ "9001:6500" ];
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/mnt:/mnt"
            "/opt/media/rdtclient/data:/data"
            "/opt/media/rdtclient/data/db:/data/db"
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
