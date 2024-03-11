{ pkgs, ... }: {
  caddy-custom = pkgs.callPackage ./overlays/caddy-custom.nix {};
  plasma-rose-pine = pkgs.callPackage ./overlays/plasma-rose-pine.nix {};
}
