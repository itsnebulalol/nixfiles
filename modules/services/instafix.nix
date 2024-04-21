{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.instafix.enable = lib.mkEnableOption "InstaFix";

  config = lib.mkIf config.services.instafix.enable {
    services.docker.enable = true;

    os.virtualisation.arion.projects.server.settings.services = {
      instafix.service = {
        image = "ghcr.io/stekc/instafix:main";
        container_name = "instafix";
        ports = [ "2858:3000" ];
        restart = "unless-stopped";
      };
    };
  };
}
