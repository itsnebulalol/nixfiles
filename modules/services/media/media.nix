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
    osModules = [inputs.arion.nixosModules.arion];

    os = {
      virtualisation.arion.backend = "docker";
      virtualisation.docker.enable = true;
      users.users.nebula.extraGroups = [ "docker" ];

      users.groups."${config.services.media.group.name}" = {
        inherit (config.services.media.group) gid;
      };

      systemd.tmpfiles.rules = [
        "d /etc/media 0770 nebula ${config.services.media.group.name} -"

        "d /mnt 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/symlinks 0770 nebula ${config.services.media.group.name} -"
        "d /mnt/libraries 0770 nebula ${config.services.media.group.name} -"
      ];

      networking.firewall.allowedTCPPorts = [80 443];

      environment.etc."caddy/cloudflare".source = osConfig.age.secrets.caddy-cloudflare.path;
      services.caddy = {
        package = pkgs.caddy-custom;
        extraConfig = ''
          import ./cloudflare
        '';
      };
    };
  };
}
