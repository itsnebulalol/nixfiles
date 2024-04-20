{
  config,
  lib,
  inputs,
  osConfig,
  pkgs,
  ...
}: {
  options.services.media.enable = lib.mkEnableOption "mediaserver";
  options.services.media.group = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "media";
    };
    gid = lib.mkOption {
      type = lib.types.int;
      default = 1337;
    };
  };

  config = lib.mkIf config.services.media.enable {
    services = {
      caddy-internal.enable = true;
      docker.enable = true;
    };

    os = {
      users.groups."${config.services.media.group.name}" = {
        inherit (config.services.media.group) gid;
      };

      systemd.tmpfiles.rules = [
        "d /etc/media 0770 nebula ${config.services.media.group.name} -"

        "d /mnt 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/symlinks 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/libraries 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/local 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/local/transcodes 0770 nebula ${config.services.media.group.name} -"
      ];
    };
  };
}
