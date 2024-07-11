{
  config,
  lib,
  ...
}: {
  options.services.media.oneary.enable = lib.mkEnableOption "Oneary" // {default = config.services.media.enable;};

  config.os = lib.mkIf (config.services.media.enable && config.services.media.oneary.enable) {
    systemd.tmpfiles.rules = [
      "d /etc/media/oneary 0770 nebula ${config.services.media.group.name} -"
    ];

    virtualisation.arion.projects.media.settings.services = {
      oneary.service = {
        image = "docker.io/itsnebulalol/oneary";
        container_name = "oneary";
        ports = [ "5398:5000" ];
        user = "1000:1337";
        volumes = [
          "/etc/media/oneary:/app/config"
          "/mnt:/mnt"
        ];
        restart = "unless-stopped";
      };
    };
  };
}
