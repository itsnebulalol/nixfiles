{
  pkgs,
  lib,
  config,
  hmConfig,
  ...
}: {
  options.programs.firefox.enable = lib.mkEnableOption "firefox";

  config.hm = lib.mkIf config.programs.firefox.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {
        extraPolicies = {
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;

          PasswordManagerEnabled = false;
        };
      };
      profiles."nebula" = {
        id = 0;
        name = "nebula";
        isDefault = true;
        settings = {
          "middlemouse.paste" = false;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          refined-github
          ublock-origin
          sponsorblock
          youtube-shorts-block
          onepassword-password-manager
        ];
      };
    };
  };
}