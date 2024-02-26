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
    shareName = strOption;
    path = strOption;
  };

  config.os = mkIf cfg.enable {
    services = {
      samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        extraConfig = ''
          workgroup = WORKGROUP
          server string = ${cfg.serverName}
          netbios name = ${cfg.serverName}
          security = user
          hosts allow = 192.168.1. 127.0.0.1 localhost
          hosts deny = 0.0.0.0/0
          guest account = nobody
          map to guest = bad user
        '';
        shares = {
          ${cfg.shareName} = {
            path = cfg.shareName;
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "nebula";
            "force group" = "users";
          };
        };
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
