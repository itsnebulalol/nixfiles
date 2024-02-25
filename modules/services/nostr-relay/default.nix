{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.nostr-relay.enable = lib.mkEnableOption "nostr-relay";

  config.os = lib.mkIf config.services.nostr-relay.enable {
    environment.systemPackages = [ pkgs.nostr-rs-relay ];

    systemd.services.nostr-rs-relay = {
      description = "Nostr relay written in Rust";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        WorkingDirectory = "/etc/nostr-rs-relay";
        ExecStart = "${lib.getExe pkgs.nostr-rs-relay}";
        ExecReload = "+/run/current-system/sw/bin/kill -HUP $MAINPID";

        Type = "simple";

        User = "nostr";
        Group = "nostr";

        ReadWritePaths = [ "/etc/nostr-rs-relay" ];

        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    systemd.tmpfiles.rules = [
      "d /etc/nostr-rs-relay 0770 nostr nostr -"
    ];

    environment.etc."nostr-rs-relay/config.toml".source = ./config.toml;

    users.users.nostr = {
      description = "nostr-rs-relay daemon user";
      isSystemUser = true;
      group = "nostr";
    };

    users.groups.nostr = {};

    services.caddy = {
      enable = true;
      virtualHosts."nostr.itsnebula.net".extraConfig = ''
        reverse_proxy 127.0.0.1:4629
      '';
    };
  };
}
