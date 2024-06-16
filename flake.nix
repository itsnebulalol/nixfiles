{
  description = "Nebula's NixOS config flake";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    arion.url = "github:hercules-ci/arion";
    conduwuit.url = "github:girlbossceo/conduwuit";
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
    nvchad-config = {
      flake = false;
      url = "github:itsnebulalol/nvchad-config";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    tiny-dfr.url = "github:itsnebulalol/tiny-dfr";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
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
      # Dell PowerEdge 2900
      consus = combinedManager.nixosSystem {
        inherit inputs;
        configuration = {
          system = "x86_64-linux";
          modules = [
            ./modules
            ./hosts/consus
            ./configs/consus
          ];
        };
      };

      # Dell Inspiron
      geras = combinedManager.nixosSystem {
        inherit inputs;
        configuration = {
          system = "x86_64-linux";
          modules = [
            ./modules
            ./hosts/geras
            ./configs/geras
          ];
        };
      };

      # Oracle VPS 3
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

      # Oracle VPS (test)
      oizys = combinedManager.nixosSystem {
        inherit inputs;
        configuration = {
          system = "x86_64-linux";
          modules = [
            ./modules
            ./hosts/oizys
            ./configs/oizys
          ];
        };
      };

      # Oracle VPS 2
      poseidon = combinedManager.nixosSystem {
        inherit inputs;
        configuration = {
          system = "aarch64-linux";
          modules = [
            ./modules
            ./hosts/poseidon
            ./configs/poseidon
          ];
        };
      };
    };
  };
}
