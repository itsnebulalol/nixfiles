{
  config,
  lib,
  inputs,
  ...
}: {
  options.services.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf options.services.docker.enable {
    osModules = [inputs.arion.nixosModules.arion];

    os = {
      virtualisation = {
        docker.enable = true;
        arion.backend = "docker";
      };

      users.users.nebula.extraGroups = [ "docker" ];
    };
  };
}
