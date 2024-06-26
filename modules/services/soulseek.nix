{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  options.services.soulseek.enable = lib.mkEnableOption "Soulseek";

  config = lib.mkIf config.services.soulseek.enable {
    services.caddy-internal.enable = true;

    os = {
      services.slskd = {
        enable = true;
        openFirewall = true;
      };

      services.caddy = {
        enable = true;
        virtualHosts = {
          "soulseek.itsnebula.net".extraConfig = ''
            reverse_proxy 127.0.0.1:5030
            import cloudflare
          '';
        };
      };
    };
  };
}
