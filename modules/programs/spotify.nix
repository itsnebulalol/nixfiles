{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.spotify.enable = lib.mkEnableOption "Spotify";

  os.programs.spicetify = lib.mkIf config.programs.spotify.enable {
    enable = true;

    spotifyPackage = pkgs.spotify;
    spicetifyPackage = pkgs.spicetify-cli;

    # rosepine color scheme
    colorScheme = "custom";
    customColorScheme = {
      text = "ebbcba";
      subtext = "F0F0F0";
      sidebar-text = "e0def4";
      main = "191724";
      sidebar = "2a2837";
      player = "191724";
      card = "191724";
      shadow = "1f1d2e";
      selected-row = "797979";
      button = "31748f";
      button-active = "31748f";
      button-disabled = "555169";
      tab-active = "ebbcba";
      notification = "1db954";
      notification-error = "eb6f92";
      misc = "6e6a86";
    };

    enabledExtensions = with spicePkgs.extensions; [
      lastfm
      hidePodcasts
      shuffle
    ];
  };
}
