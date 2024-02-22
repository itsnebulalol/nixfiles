let
  arete_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPQbrPo6LqXSvUYbHTVPymkWhhb4jhlBSjIUYs4JMHL";
  arete_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYNR27SPgJINtB95y5v+T80V3yK5RTd+c0NKho6yRWE";
  arete = [arete_user arete_host];

  # cratos_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv";
  # cratos_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv";
  # cratos = [cratos_user cratos_host];

  semreh_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVho+KHY8MayDm1un32hZUZt6H4SsMTboEwvQzYuf5E";
  semreh_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOczbXpTKp8QZoOI/+5pvLYNXXpC6E2/fyZU32wWaxw6";
  semreh = [semreh_user semreh_host];

in {
  "tailscale.age".publicKeys = arete ++ semreh;
}
