{pkgs, ...}: {
  users.main = "nebula";

  rebuildCommand = "nh os switch $argv -- --impure";

  agenix.enable = true;
  bluetooth.enable = true;

  programs = {
    _1password.enable = true;
    chromium.enable = true;
    gnome.enable = true;
    discord.enable = true;
    minecraft.enable = true;
    vscode.enable = true;
  };

  services = {
    tailscale.enable = true;
    tiny-dfr.enable = true;
  };

  hm.home.packages = with pkgs; [
    neofetch
  ];

  os = {
    services.upower.enable = true;
    programs.nm-applet.enable = true;
  };
}
