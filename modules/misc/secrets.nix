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
        age.secrets = lib.mkMerge [
          (secretForHostnames ["semreh"] ../../secrets/cloudflared-home.age "cloudflared-home" { owner = "cloudflared"; })
          (secretForHostnames ["poseidon" "semreh"] ../../secrets/cloudflared-media.age "cloudflared-media" { owner = "cloudflared"; })
          (secretForHostnames ["arete" "geras" "mainae" "oizys" "poseidon" "semreh"] ../../secrets/tailscale.age "tailscale" {})
        ];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
      };

      hm.age = {
        secrets = lib.mkMerge [
          (secretForHostnames ["arete" "semreh"] ../../secrets/wakatime.age "wakatime" {})
        ];
        identityPaths = ["/home/nebula/.ssh/id_ed25519"];
      };
    })
  ];
}
