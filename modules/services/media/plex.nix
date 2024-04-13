{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.media.plex.enable = lib.mkEnableOption "Plex" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.plex.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/plex 0770 nebula ${config.services.media.group.name} -"
      "d /etc/media/overseerr 0770 nebula ${config.services.media.group.name} -"

      "d /mnt/local/transcodes/plex 0770 nebula ${config.services.media.group.name} -"
    ];

    #services.plex = {
    #  enable = true;
    #  user = "nebula";
    #  group = config.services.media.group.name;
    #  dataDir = "/etc/media/plex";
    #  openFirewall = true;
    #};

    virtualisation.arion.projects.media.settings.services = {
      plex.service = {
        image = "lscr.io/linuxserver/plex:latest";
        container_name = "plex";
        network_mode = "host";
        volumes = [
          "/etc/media/plex:/config"
          "/mnt/local/transcodes/plex:/transcode"
          "/mnt:/mnt"
          "/dev/shm:/dev/shm"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";
          VERSION = "docker";
        };
        restart = "unless-stopped";
      };

      overseerr.service = {
        image = "sctx/overseerr:latest";
        container_name = "overseerr";
        ports = [ "9007:9007" ];
        volumes = [
          "/etc/media/overseerr:/app/config"
        ];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          PGID = "1337";

          PORT = "9007";
        };
        restart = "unless-stopped";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 32400 3005 8324 32469 ];
      allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "6d34d7bd-8df4-4e28-9f06-b0674d0408dc" = {
          credentialsFile = osConfig.age.secrets.cloudflared-media.path;
          ingress = {
            "plex.itsnebula.net" = "http://127.0.0.1:32400";
            "requests.itsnebula.net" = "http://127.0.0.1:9007";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
