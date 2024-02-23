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

    services.caddy = {
      enable = true;
      virtualHosts = {
        "f.itsnebula.net".extraConfig = ''
          reverse_proxy server.coin-gray.ts.net:5381
        '';

        "ig.itsnebula.net".extraConfig = ''
          reverse_proxy server.coin-gray.ts.net:2741
        '';
      };
    };
  };
}
