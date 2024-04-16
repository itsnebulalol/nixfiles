{ pkgs, ... }: {
  caddy-custom = pkgs.callPackage ./overlays/caddy-custom.nix {};
  jellyfin-web = pkgs.callPackage ./overlays/jellyfin-web {};
  plasma-rose-pine = pkgs.callPackage ./overlays/plasma-rose-pine.nix {};
}
