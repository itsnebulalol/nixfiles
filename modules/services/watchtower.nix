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
        ports = [ "2741:3000" ];
        restart = "unless-stopped";
      };
    };
  };
}
