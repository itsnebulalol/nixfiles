let
  arete_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPQbrPo6LqXSvUYbHTVPymkWhhb4jhlBSjIUYs4JMHL";
  arete_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYNR27SPgJINtB95y5v+T80V3yK5RTd+c0NKho6yRWE";
  arete = [arete_user arete_host];

  # cratos_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv";
  # cratos_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCzv/x3Mly7m621sMV+jtlyFRtazkfA6B6m8yMIV1Yv";
  # cratos = [cratos_user cratos_host];

  geras_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9igQb33UXH8wAGTC+K7w6uBdciIKI03Xxc2JcoAJNz";
  geras_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVxSXFgepyJf3LilMcmjhIDrUw9dnvs76/timPjNdGB";
  geras = [geras_user geras_host];

  oizys_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqkRtQeZtjoaEG8oxqALkkEedsPlvMIMNrszYTf1aiU";
  oizys_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8YzwzjrPrzKHBaeOeSCRGqUJEDhaP684czaY5Gj/Nu";
  oizys = [oizys_user oizys_host];

  semreh_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVho+KHY8MayDm1un32hZUZt6H4SsMTboEwvQzYuf5E";
  semreh_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOczbXpTKp8QZoOI/+5pvLYNXXpC6E2/fyZU32wWaxw6";
  semreh = [semreh_user semreh_host];

in {
  "cloudflared.age".publicKeys = semreh;
  "tailscale.age".publicKeys = arete ++ geras ++ oizys ++ semreh;
  "wakatime.age".publicKeys = arete;
}
