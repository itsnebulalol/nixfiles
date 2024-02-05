_: {
  hm.programs.git = {
    enable = true;
    userName = "Nebula";
    userEmail = "me@itsnebula.net";
    extraConfig = {
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv";
      github.user = "itsnebulalol";
      pull.rebase = false;
      commit.gpgSign = true;
      gpg.format = "ssh";
      color.ui = true;
      merge.clonflictStyle = "diff3";
      init.defaultBranch = "main";
      gpg."ssh".program = "/opt/1Password/op-ssh-sign";
    };
  };
}
