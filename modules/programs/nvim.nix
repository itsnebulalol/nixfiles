{
  pkgs,
  lib,
  config,
  hmConfig,
  ...
}: {
  config.os = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  config.hm.xdg.configFile."nvim" = {
    source = hmConfig.lib.file.mkOutOfStoreSymlink "${pkgs.nvchad}";
    recursive = true;
  };
}
