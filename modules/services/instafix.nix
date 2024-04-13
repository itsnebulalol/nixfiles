{
  config,
  lib,
  ...
}: {
  options.services.instafix.enable = lib.mkEnableOption "InstaFix";

  config = lib.mkIf config.services.instafix.enable {
    services.docker.enable = true;

    os.virtualisation.arion.projects.server.settings.services = {
      instafix.service = {
        image = "ghcr.io/stekc/instafix:main";
        container_name = "instafix";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        restart = "unless-stopped";
      };
    };
  };
}
