{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.minecraft.enable = lib.mkEnableOption "Minecraft";

  config.hm = lib.mkIf config.programs.minecraft.enable {
    home.packages = [pkgs.prismlauncher pkgs.glfw-wayland-minecraft];
  };
}
