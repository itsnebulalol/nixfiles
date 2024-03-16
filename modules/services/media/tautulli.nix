{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.media.tautulli.enable = lib.mkEnableOption "Tautulli" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.tautulli.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/tautulli 0770 nebula ${config.services.media.group.name} -"
    ];

    services.tautulli = {
      enable = true;
      user = "nebula";
      group = config.services.media.group.name;
      dataDir = "/etc/media/tautulli";
      openFirewall = true;
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "6d34d7bd-8df4-4e28-9f06-b0674d0408dc" = {
          credentialsFile = osConfig.age.secrets.cloudflared-media.path;
          ingress = {
            "tautulli.itsnebula.net" = "http://127.0.0.1:8181";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
