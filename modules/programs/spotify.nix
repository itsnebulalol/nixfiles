{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  options.programs.spotify.enable = lib.mkEnableOption "Spotify";

  config = lib.mkMerge [
    (lib.mkIf config.programs.spotify.enable {
      hmModules = [inputs.spicetify-nix.homeManagerModule];

      os.programs.spicetify = {
        enable = true;

        spotifyPackage = pkgs.spotify;
        spicetifyPackage = pkgs.spicetify-cli;

        theme = spicePkgs.themes.ziro;
        colorScheme = "rose-pine";

        enabledExtensions = with spicePkgs.extensions; [
          lastfm
          hidePodcasts
          shuffle
        ];
      };
    })
  ];
}
