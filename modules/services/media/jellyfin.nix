{
  config,
  lib,
  osConfig,
  pkgs,
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
      package = pkgs.jellyfin.overrideAttrs (old: {
        version = "master";
        src = pkgs.fetchFromGitHub {
          owner = "jellyfin";
          repo = "jellyfin";
          rev = "master";
          hash = "SKIP";
        };
      });
      user = "nebula";
      group = config.services.media.group.name;
      dataDir = "/etc/media/jellyfin";
      openFirewall = true;
    };

    virtualisation.arion.projects.media.settings.services = {
      jellyseerr.service = {
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

    services.cloudflared = {
      enable = true;
      tunnels = {
        "6d34d7bd-8df4-4e28-9f06-b0674d0408dc" = {
          credentialsFile = osConfig.age.secrets.cloudflared-media.path;
          ingress = {
            "jellyfin.itsnebula.net" = "http://127.0.0.1:8096";
            "privaterequests.itsnebula.net" = "http://127.0.0.1:9008";
          };
          default = "http_status:404";
        };
      };
    };
  };
}