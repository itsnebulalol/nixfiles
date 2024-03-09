{
  config,
  lib,
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
    osModules = [inputs.arion.nixosModules.arion];

    os = {
      virtualisation.arion.backend = "docker";

      users.groups."${config.services.media.group.name}" = {
        inherit (config.services.media.group) gid;
      };

      systemd.tmpfiles.rules = [
        "d /opt/media 0770 nebula ${config.services.media.group.name} -"
      ];
    };
  };
}
