{
  config,
  lib,
  ...
}: {
  options.services.scrypted.enable = lib.mkEnableOption "Scrypted";

  config = lib.mkIf config.services.scrypted.enable {
    services.docker.enable = true;

    os = {
      systemd.tmpfiles.rules = [
        "d /etc/scrypted 0770 nebula users -"
      ];

      virtualisation.arion.projects.server.settings.services = {
        scrypted = {
          out.service = {
            security_opt = ["apparmor:unconfined"];
          };

          service = {
            image = "ghcr.io/koush/scrypted";
            container_name = "scrypted";
            network_mode = "host";
            devices = [ "/dev/dri:/dev/dri" ];
            volumes = [
              "/var/run/dbus:/var/run/dbus"
              "/var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket"
              "/etc/scrypted:/server/volume"
            ];
            restart = "unless-stopped";
          };
        };
      };
    };
  };
}
