{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: let
  discord_dataDir = "/var/lib/mautrix-discord";
  discord_registrationFile = "${discord_dataDir}/discord-registration.yaml";
  discord_settingsFile = "${discord_dataDir}/config.yaml";
  discord_settingsFileUnsubstituted = settingsFormat.generate "mautrix-discord-config-unsubstituted.json" discord_settings;
  settingsFormat = pkgs.formats.json {};

  discord_settings = {
    homeserver = {
      address = "http://localhost:6167";
      public_address = "https://matrix.itsnebula.net";
      domain = "itsnebula.net";
    };
    appservice = {
      hostname = "127.0.0.1";
      port = 29328;
      database = {
        type = "sqlite3";
        uri = "file:${discord_dataDir}/mautrix-discord.db?_txlock=immediate";
      };
      id = "discord";
      bot = {
        username = "discordbot";
        displayname = "Discord Bridge Bot";
      };
      as_token = "";
      hs_token = "";
    };
    bridge = {
      username_template = "discord_{{.}}";
      displayname_template = "{{or .GlobalName .Username}}{{if .Bot}} (bot){{end}}";
      channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}}{{else}}#{{.Name}}{{end}}";
      guild_name_template = "{{.Name}}";
      private_chat_portal_meta = "default";
      double_puppet_server_map = { };
      login_shared_secret_map = { };
      command_prefix = "!discord";
      permissions = {
        "*" = "relay";
        "@nebula:itsnebula.net" = "admin";
      };
      relay.enabled = true;
    };
    logging = {
      min_level = "info";
      writers = lib.singleton {
        type = "stdout";
        format = "pretty-colored";
        time_format = " ";
      };
    };
  };
in {
  options.services.conduit.enable = lib.mkEnableOption "conduit";

  config.os = lib.mkIf config.services.conduit.enable {
    services.matrix-conduit = {
      package = inputs.conduwuit.packages.${pkgs.system}.default;
      enable = true;
      settings.global = {
        address = "0.0.0.0";
        server_name = "itsnebula.net";
        database_backend = "rocksdb";
        new_user_displayname_suffix = "";
      };
    };

    # mautrix-discord
    users.users.mautrix-discord = {
      isSystemUser = true;
      group = "mautrix-discord";
      home = discord_dataDir;
      description = "Mautrix-Discord bridge user";
    };
    users.groups.mautrix-discord = {};

    systemd.services.mautrix-discord = {
      description = "mautrix-discord, a Matrix-Discord puppeting bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" "conduit.service" ];
      after = [ "network-online.target" "conduit.service" ];

      preStart = ''
        # substitute the settings file by environment variables
        # in this case read from EnvironmentFile
        test -f '${discord_settingsFile}' && rm -f '${discord_settingsFile}'
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o '${discord_settingsFile}' \
          -i '${discord_settingsFileUnsubstituted}'
        umask $old_umask

        # generate the appservice's registration file if absent
        if [ ! -f '${discord_registrationFile}' ]; then
          ${pkgs.mautrix-discord}/bin/mautrix-discord \
            --generate-registration \
            --config='${discord_settingsFile}' \
            --registration='${discord_registrationFile}'
        fi
        chmod 640 ${discord_registrationFile}

        umask 0177
        ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
          | .[0].appservice.hs_token = .[1].hs_token
          | .[0]' \
          '${discord_settingsFile}' '${discord_registrationFile}' > '${discord_settingsFile}.tmp'
        mv '${discord_settingsFile}.tmp' '${discord_settingsFile}'
        umask $old_umask
      '';

      serviceConfig = {
        User = "mautrix-discord";
        Group = "mautrix-discord";
        StateDirectory = baseNameOf discord_dataDir;
        WorkingDirectory = discord_dataDir;
        ExecStart = ''
          ${pkgs.mautrix-discord}/bin/mautrix-discord \
          --config='${discord_settingsFile}' \
          --registration='${discord_registrationFile}'
        '';
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];
        Type = "simple";
        UMask = 0027;
      };
      restartTriggers = [ discord_settingsFileUnsubstituted ];
    };
  };
}
