{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.services.samba;
  inherit (lib) mkEnableOption mkOption types mkIf;

  strOption = mkOption {
    type = types.str;
  };
in {
  options.services.samba = {
    enable = mkEnableOption "Samba";

    serverName = strOption;
    globalConfig = strOption;
    shares = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config.os = mkIf cfg.enable {
    services = {
      samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        extraConfig = ''
          fruit:aapl = yes
          workgroup = WORKGROUP
          server string = ${cfg.serverName}
          netbios name = ${cfg.serverName}
          security = user
          hosts allow = 192.168.1. 127.0.0.1 localhost
          hosts deny = 0.0.0.0/0
          guest account = nobody
          map to guest = bad user
          ${cfg.globalConfig}
        '';
        shares = cfg.shares;
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
