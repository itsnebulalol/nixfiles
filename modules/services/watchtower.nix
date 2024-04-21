{
  config,
  lib,
  ...
}: {
  options.services.watchtower.enable = lib.mkEnableOption "Watchtower";

  config = lib.mkIf config.services.watchtower.enable {
    services.docker.enable = true;

    os.virtualisation.arion.projects.server.settings.services = {
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
