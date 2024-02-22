{
  description = "Nebulas's NixOS config flake";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    nix-super.url = "github:privatevoid-net/nix-super";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    plasma-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
      url = "github:pjones/plasma-manager";
    };
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:viperML/nh";
    };
    nur.url = "github:nix-community/NUR";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    tiny-dfr.url = "github:itsnebulalol/tiny-dfr";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];

    combinedManager = import (builtins.fetchTarball {
      url = "https://github.com/flafydev/combined-manager/archive/9474a2432b47c0e6fa0435eb612a32e28cbd99ea.tar.gz";
      sha256 = "sha256:04rzv1ajxrcmjybk1agpv4rpwivy7g8mwfms8j3lhn09bqjqrxxf";
    });
  in {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

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

      # PC
      cratos = combinedManager.nixosSystem {
        system = "x86_64-linux";
        inherit inputs;
        modules = [
          ./modules
          ./hosts/cratos
          ./configs/cratos
        ];
      };

      # Raspberry Pi 4
      semreh = combinedManager.nixosSystem {
        system = "aarch64-linux";
        inherit inputs;
        modules = [
          ./modules
          ./hosts/semreh
          ./configs/semreh
        ];
      };
    };
  };
}
