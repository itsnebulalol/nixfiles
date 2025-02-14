{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  options.services.caddy.enable = lib.mkEnableOption "Caddy";

  config.os = lib.mkIf config.services.caddy.enable {
    networking.firewall.allowedTCPPorts = [80 443];
    environment.etc."caddy/cloudflare".source = osConfig.age.secrets.caddy-cloudflare.path;

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
        ];
        hash = "sha256-jCcSzenewQiW897GFHF9WAcVkGaS/oUu63crJu7AyyQ=";
      };
      extraConfig = ''
        import ./cloudflare
      '';
      virtualHosts = {
        "f.itsnebula.net".extraConfig = ''
          reverse_proxy 10.13.0.105:15000
          import cloudflare
        '';

        "attic.svrd.me".extraConfig = ''
          reverse_proxy 10.13.0.13:7777
          import cloudflare
        '';

        "ntfy.svrd.me".extraConfig = ''
          reverse_proxy 10.13.0.21:8080
          import cloudflare
        '';

        "frigate.h.svrd.me".extraConfig = ''
          reverse_proxy 10.13.0.16:8971
          import cloudflare
        '';

        "hass.h.svrd.me".extraConfig = ''
          reverse_proxy 10.13.0.20:8123
          import cloudflare
        '';
      };
    };
  };
}
