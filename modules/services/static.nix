{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.services.static.enable = lib.mkEnableOption "Static";

  config.os = lib.mkIf config.services.static.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        ":7697".extraConfig = ''
          root * /data/Static
          file_server browse
        '';
      };
    };
  };
}

