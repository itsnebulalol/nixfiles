{
  pkgs,
  config,
  ...
}: {
  config.os = {
    environment.systemPackages = [ pkgs.vim ]; 

    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
