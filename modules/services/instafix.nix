{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.instafix.enable = lib.mkEnableOption "InstaFix";

  config = lib.mkIf config.services.instafix.enable {
    services.docker.enable = true;

    os = {
      virtualisation.arion.projects.server.settings.services = {
        instafix.service = {
          image = "ghcr.io/stekc/instafix:main";
          container_name = "instafix";
          ports = [ "2858:3000" ];
          restart = "unless-stopped";
        };
      };

      services.cloudflared = {
        enable = true;
        tunnels = {
          "4978c8b8-c9fe-47b9-af50-d59921ebdde1" = {
            credentialsFile = osConfig.age.secrets.cloudflared-home.path;
            ingress = {
              "ig.itsnebula.net" = "http://127.0.0.1:2858";
            };
            default = "http_status:404";
          };
        };
      };
    };
  };
}
