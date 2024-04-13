{
  config,
  lib,
  osConfig,
  ...
}: {
  options.services.adguard.enable = lib.mkEnableOption "AdGuard";

  config = lib.mkIf config.services.adguard.enable {
    services.docker.enable = true;

    os = {
      services.adguardhome = {
        enable = true;
        openFirewall = true;
      };

      systemd.services.adguardhome.preStart = ''
        cp --force "${./config.yml}" "$STATE_DIRECTORY/AdGuardHome.yaml"
        chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
      '';

      networking.firewall.allowedUDPPorts = [53];

      virtualisation.arion.projects.server.settings.services = {
        adguardhome-sync.service = {
          image = "ghcr.io/bakito/adguardhome-sync";
          container_name = "adguardhome-sync";
          volumes = [
            # TODO: adguardhome-sync secret
            # "{osConfig.age.secrets.adguardhome_sync.path}:/config/adguardhome-sync.yaml"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          command = [ "run" "--config" "/config/adguardhome-sync.yaml" ];
          restart = "unless-stopped";
        };
      };
    };
  };
}
