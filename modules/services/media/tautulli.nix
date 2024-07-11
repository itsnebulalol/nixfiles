{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.media.tautulli.enable = lib.mkEnableOption "Tautulli";

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
    
    services.caddy = {
      enable = true;
      virtualHosts = {
        "tautulli.svrd.me".extraConfig = ''
          reverse_proxy 127.0.0.1:8181
          import cloudflare
        '';
      };
    };
  };
}
