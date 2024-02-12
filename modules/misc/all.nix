{
  config,
  ...
}: {
  config.os.environment.sessionVariables.NIXOS_OZONE_WL = "1";
  config.os.zramSwap.enable = true;
}