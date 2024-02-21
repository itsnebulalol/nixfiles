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
      color.ui = true;
      merge.clonflictStyle = "diff3";
      init.defaultBranch = "main";
      gpg = {
        format = "ssh";
        "ssh".program = "/run/current-system/sw/bin/op-ssh-sign";
      };
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
