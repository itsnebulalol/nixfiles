{
  config,
  lib,
  ...
}: {
  options.services.media.notifiarr.enable = lib.mkEnableOption "Notifiarr" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.notifiarr.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/notifiarr 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      notifiarr = {
        service = {
          image = "docker.io/golift/notifiarr";
          container_name = "notifiarr";
          ports = [ "5454:5454" ];
          volumes = [
            "/etc/media/notifiarr:/config"
            "/var/run/utmp:/var/run/utmp"
            "/etc/machine-id:/etc/machine-id"
          ];
          restart = "unless-stopped";
        };
      };
    };
  };
}
