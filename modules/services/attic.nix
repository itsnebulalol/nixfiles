{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.services.attic.enable = lib.mkEnableOption "Attic";

  config = lib.mkIf config.services.attic.enable {
    osModules = [inputs.attic.nixosModules.atticd];

    os = {
      services.atticd = {
        enable = true;
        environmentFile = "/root/attic_token";
        settings = {
          listen = "[::]:7777";
          jwt = {};
          chunking = {
            nar-size-threshold = 64 * 1024;
            min-size = 16 * 1024;
            avg-size = 64 * 1024;
            max-size = 256 * 1024;
          };
        };
      };
    };
  };
}
