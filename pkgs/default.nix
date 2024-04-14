{ pkgs, ... }: {
  caddy-custom = pkgs.callPackage ./overlays/caddy-custom.nix {};
  jellyfin-web = pkgs.callPackage ./overlays/jellyfin-web {};
  nvchad = pkgs.callPackage ./overlays/nvchad.nix {};
  plasma-rose-pine = pkgs.callPackage ./overlays/plasma-rose-pine.nix {};
}
