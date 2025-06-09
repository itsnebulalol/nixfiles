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
          "github.com/caddy-dns/cloudflare@v0.2.2-0.20250506153119-35fb8474f57d"
        ];
        hash = "sha256-xMxNAg08LDVifhsryGXV22LXqgRDdfjmsU0NfbUJgMg=";
      };
      extraConfig = ''
        import ./cloudflare
      '';
      virtualHosts = {
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
