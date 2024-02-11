{
  hmConfig,
  ...
}: {
  os.services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  hm = {
    programs.ssh.enable = true;
  };
}