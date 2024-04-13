{
  config,
  lib,
  ...
}: {
  options.services.adguard.enable = lib.mkEnableOption "AdGuard";

  config.os = lib.mkIf config.services.adguard.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
    };

    systemd.services.adguardhome.preStart = ''
      cp --force "${./config.yml}" "$STATE_DIRECTORY/AdGuardHome.yaml"
      chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
    '';

    networking.firewall.allowedUDPPorts = [53];
  };
}
