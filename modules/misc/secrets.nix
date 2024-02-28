{
  config,
  osConfig,
  lib,
  inputs,
  pkgs,
  ...
}: let
  secretForHostnames = hostnames: secretFile: secretName: extra:
    lib.mkIf (builtins.elem osConfig.networking.hostName hostnames) {
      ${secretName} =
        {
          file = secretFile;
        }
        // extra;
    };
in {
  options.agenix.enable = lib.mkEnableOption "agenix";

  config = lib.mkMerge [
    (lib.mkIf config.agenix.enable {
      osModules = [inputs.agenix.nixosModules.default];
      hmModules = [inputs.agenix.homeManagerModules.default];

      os = {
        age = {
          secrets = lib.mkMerge [
            (secretForHostnames ["arete" "geras" "semreh"] ../../secrets/tailscale.age "tailscale" {})
            (secretForHostnames ["semreh"] ../../secrets/cloudflared.age "cloudflared" { owner = "cloudflared"; })
          ];
          identityPaths = ["/home/nebula/.ssh/id_ed25519"];
        };
        environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
      };
    })
  ];
}
