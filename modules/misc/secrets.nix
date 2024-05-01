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
          (secretForHostnames ["consus"] ../../secrets/adguardhome_sync.age "adguardhome_sync" { owner = "nebula"; })
          (secretForHostnames ["consus" "poseidon"] ../../secrets/blackhole.age "blackhole" {})
          (secretForHostnames ["consus" "poseidon"] ../../secrets/blackhole4k.age "blackhole4k" {})
          (secretForHostnames ["consus" "poseidon"] ../../secrets/blackhole4kdv.age "blackhole4kdv" {})
          (secretForHostnames ["consus" "poseidon"] ../../secrets/blackholeextra.age "blackholeextra" {})
          (secretForHostnames ["consus" "maniae" "poseidon" "semreh"] ../../secrets/caddy-cloudflare.age "caddy-cloudflare" { owner = "caddy"; })
          (secretForHostnames ["consus" "semreh"] ../../secrets/cloudflared-home.age "cloudflared-home" { owner = "cloudflared"; })
          (secretForHostnames ["consus" "poseidon"] ../../secrets/cloudflared-media.age "cloudflared-media" { owner = "cloudflared"; })
          (secretForHostnames ["consus" "poseidon"] ../../secrets/homepage_env.age "homepage_env" {})
          (secretForHostnames ["consus" "poseidon"] ../../secrets/rd_conf.age "rd_conf" {})
          (secretForHostnames ["arete" "consus" "geras" "maniae" "oizys" "poseidon" "semreh"] ../../secrets/tailscale.age "tailscale" {})
          (secretForHostnames ["consus" "poseidon"] ../../secrets/wg-home.age "wg-home" {})
        ];
        environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
      };

      hm.age = {
        secrets = lib.mkMerge [
          (secretForHostnames ["arete" "consus"] ../../secrets/wakatime.age "wakatime" {})
        ];
        identityPaths = ["/home/nebula/.ssh/id_ed25519"];
      };
    })
  ];
}
