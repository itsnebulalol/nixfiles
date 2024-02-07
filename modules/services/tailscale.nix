{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.services.tailscale.enable = lib.mkEnableOption "Tailscale";

  config.os = lib.mkIf config.services.tailscale.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    services.tailscale.enable = true;
    services.tailscale.authKeyFile = osConfig.age.secrets.tailscale.path;
  };
}
