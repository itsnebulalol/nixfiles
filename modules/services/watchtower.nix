{
  config,
  lib,
  ...
}: {
  options.services.watchtower.enable = lib.mkEnableOption "Watchtower";

  config.os = lib.mkIf config.services.watchtower.enable {
    virtualisation.arion.projects.server.settings.services = {
      watchtower.service = {
        image = "containrrr/watchtower";
        container_name = "watchtower";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        restart = "unless-stopped";
      };
    };
  };
}
