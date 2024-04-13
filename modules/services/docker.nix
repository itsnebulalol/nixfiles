{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.services.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.services.docker.enable {
    osModules = [inputs.arion.nixosModules.arion];

    os = {
      virtualisation = {
        docker.enable = true;
        arion.backend = "docker";
      };

      environment.systemPackages = with pkgs; [ docker-compose ];

      users.users.nebula.extraGroups = [ "docker" ];
    };
  };
}
