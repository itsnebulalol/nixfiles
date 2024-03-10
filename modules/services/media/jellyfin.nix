{
  config,
  lib,
  ...
}: {
  options.services.media.jellyfin.enable = lib.mkEnableOption "Jellyfin" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.jellyfin.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/jellyfin 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/jellyseerr 0770 nebula ${config.services.media.group.name} -"
    ];

    services.jellyfin = {
      enable = true;
      user = "nebula";
      group = config.services.media.group.name;
      dataDir = "/etc/media/jellyfin";
      openFirewall = true;
    };

    virtualisation.arion.projects.media.settings.services = {
      jellyseerr = {
        service = {
          image = "fallenbagel/jellyseerr:latest";
          container_name = "jellyseerr";
          ports = [ "9008:9008" ];
          volumes = [
            "/etc/media/jellyseerr:/app/config"
          ];
          environment = {
            TZ = "America/New_York";
            PUID = "1000";
            PGID = "1337";

            PORT = "9008";
          };
          restart = "unless-stopped";
        };
      };
    };
  };
}