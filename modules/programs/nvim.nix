{
  pkgs,
  lib,
  config,
  hmConfig,
  inputs,
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
    source = hmConfig.lib.file.mkOutOfStoreSymlink "${inputs.nvchad-config}";
    recursive = true;
  };
}
