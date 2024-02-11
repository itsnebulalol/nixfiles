{pkgs, ...}: {
  users.main = "nebula";

  rebuildCommand = "nh os switch -- --impure";

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
    tiny-dfr.enable = true;
    tailscale.enable = true;
  };

  hm.home.packages = with pkgs; [
    neofetch
  ];

  os = {
    services.upower.enable = true;
    programs.nm-applet.enable = true;
  };
}
