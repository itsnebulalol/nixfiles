_: prev: {
  caddy-custom = prev.callPackage ./caddy-custom.nix {};
  jellyfin-web = prev.callPackage ./jellyfin-web {};
  nvchad = prev.callPackage ./nvchad.nix {};
  plasma-rose-pine = prev.callPackage ./plasma-rose-pine.nix {};
}
