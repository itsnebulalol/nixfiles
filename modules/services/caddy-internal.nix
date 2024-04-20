{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  options.services.caddy-internal.enable = lib.mkEnableOption "Caddy Internal";

  config.os = lib.mkIf config.services.caddy-internal.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    environment.etc."caddy/cloudflare".source = osConfig.age.secrets.caddy-cloudflare.path;
    services.caddy = {
      package = pkgs.caddy-custom;
      extraConfig = ''
        import ./cloudflare
      '';
    };
  };
}
