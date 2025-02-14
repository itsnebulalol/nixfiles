{
  description = "Nebula's NixOS config flake";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    nix-super.url = "github:privatevoid-net/nix-super";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:viperML/nh";
    };
    nur.url = "github:nix-community/NUR";
    nvchad-config = {
      flake = false;
      url = "github:itsnebulalol/nvchad-config";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
    ];

    combinedManager = import (builtins.fetchTarball {
      url = "https://github.com/flafydev/combined-manager/archive/e7ba6d6b57ee03352022660fcd572c973b6b26db.tar.gz";
      sha256 = "sha256:11raq3s4d7b0crihx8pilhfp74xp58syc36xrsx6hdscyiild1z7";
    });
  in {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    nixosConfigurations = {
      # Oracle VPS
      maniae = combinedManager.nixosSystem {
        inherit inputs;
        configuration = {
          system = "aarch64-linux";
          modules = [
            ./modules
            ./hosts/maniae
            ./configs/maniae
          ];
        };
      };
    };
  };
}
