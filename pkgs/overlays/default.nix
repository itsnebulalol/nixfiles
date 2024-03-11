_: prev: {
  caddy-custom = prev.callPackage ./caddy-custom.nix {};
  plasma-rose-pine = prev.callPackage ./plasma-rose-pine.nix {};
}
