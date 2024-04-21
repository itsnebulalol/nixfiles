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
      package = pkgs.caddy-custom;
      extraConfig = ''
        import ./cloudflare
      '';
      virtualHosts = {
        "f.itsnebula.net".extraConfig = ''
          reverse_proxy consus.coin-gray.ts.net:7697
          import cloudflare
        '';

        "ig.itsnebula.net".extraConfig = ''
          reverse_proxy consus.coin-gray.ts.net:2858
          import cloudflare
        '';

        "matrix.itsnebula.net".extraConfig = ''
          reverse_proxy /_matrix/* semreh.coin-gray.ts.net:6167
          import cloudflare
        '';

        "nostr.itsnebula.net".extraConfig = ''
          reverse_proxy semreh.coin-gray.ts.net:4629
          import cloudflare
        '';
      };
    };
  };
}
