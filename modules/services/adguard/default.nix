{
  config,
  lib,
  osConfig,
  inputs,
  ...
}: let
  src = let
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "64e3c021c5cbb6ef395880f4a06a05534e2b55da";
    sha256 = "sha256:18nkg1izz2kc0yrq4y92mfjv13z6bnaq3d9lqhy89n8vs8qizv63";
  in builtins.fetchTarball {
    name = "nixpkgs";
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    inherit sha256;
  };
in {
  options.services.adguard.enable = lib.mkEnableOption "AdGuard";

  config = lib.mkIf config.services.adguard.enable {
    services.docker.enable = true;

    os = {
      disabledModules = [ "${inputs.nixpkgs}/nixos/modules/services/networking/adguardhome.nix" ];
      imports = [ "${src}/nixos/modules/services/networking/adguardhome.nix" ];

      nixpkgs.overlays = [ (_: super: { adguardhome = super.callPackage (import "${src}/pkgs/servers/adguardhome") { }; }) ];

      services.adguardhome = {
        enable = true;
        openFirewall = true;
      };

      systemd.services.adguardhome.preStart = ''
        cp --force "${./config.yml}" "$STATE_DIRECTORY/AdGuardHome.yaml"
        chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
      '';

      networking.firewall.allowedUDPPorts = [53];

      virtualisation.arion.projects.server.settings.services = {
        adguardhome-sync.service = {
          image = "ghcr.io/bakito/adguardhome-sync";
          container_name = "adguardhome-sync";
          volumes = [
            "${osConfig.age.secrets.adguardhome_sync.path}:/config/adguardhome-sync.yaml"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          command = [ "run" "--config" "/config/adguardhome-sync.yaml" ];
          restart = "unless-stopped";
        };
      };
    };
  };
}
