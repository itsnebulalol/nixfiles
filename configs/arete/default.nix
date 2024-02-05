{pkgs, ...}: {
  users.main = "nebula";

  rebuildCommand = "nh os switch $argv -- --impure";

  bluetooth.enable = true;

  programs = {
    _1password.enable = true;
    chromium.enable = true;
    discord.enable = true;
    minecraft.enable = true;
    vscode.enable = true;
  };

  hm.home.packages = with pkgs; [
    neofetch
  ];

  os.programs.nm-applet.enable = true;

  os.environment.systemPackages = [pkgs.curl pkgs.wget pkgs.aria2];
}
