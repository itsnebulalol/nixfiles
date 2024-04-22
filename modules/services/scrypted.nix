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

      networking.firewall.allowedTCPPorts = [10443 44150 31800 34538 37585 38098 42633 44989 39464 40071];

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
