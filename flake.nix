{
  description = "Nebulas's NixOS config flake";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    nix-super.url = "github:privatevoid-net/nix-super";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    tiny-dfr.url = "github:itsnebulalol/tiny-dfr";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
    ];

    combinedManager = import (builtins.fetchTarball {
      url = "https://github.com/flafydev/combined-manager/archive/9474a2432b47c0e6fa0435eb612a32e28cbd99ea.tar.gz";
      sha256 = "sha256:04rzv1ajxrcmjybk1agpv4rpwivy7g8mwfms8j3lhn09bqjqrxxf";
    });
  in {
    nixosConfigurations = {
      # M1 MacBook
      arete = combinedManager.nixosSystem {
        system = "aarch64-linux";
        inherit inputs;
        modules = [
          ./modules
          ./hosts/arete
          ./configs/arete
        ];
      };
    };
  };
}
