_: prev: {
  caddy-custom = prev.callPackage ./caddy-custom.nix {};
  jellyfin-web = prev.callPackage ./jellyfin-web {};
  plasma-rose-pine = prev.callPackage ./plasma-rose-pine.nix {};
}
