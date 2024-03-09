let
  arete_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPQbrPo6LqXSvUYbHTVPymkWhhb4jhlBSjIUYs4JMHL";
  arete_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYNR27SPgJINtB95y5v+T80V3yK5RTd+c0NKho6yRWE";
  arete = [arete_user arete_host];

  geras_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9igQb33UXH8wAGTC+K7w6uBdciIKI03Xxc2JcoAJNz";
  geras_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVxSXFgepyJf3LilMcmjhIDrUw9dnvs76/timPjNdGB";
  geras = [geras_user geras_host];

  maniae_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzIyeRCkLieiuEoCGvrBQrXgp6U/WnorBnvPW/YHL9q";
  maniae_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9qC/9rOQWjFBr9EFtc05TCIcOI9m38howi6vTPizuy";
  maniae = [maniae_user maniae_host];

  oizys_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqkRtQeZtjoaEG8oxqALkkEedsPlvMIMNrszYTf1aiU";
  oizys_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8YzwzjrPrzKHBaeOeSCRGqUJEDhaP684czaY5Gj/Nu";
  oizys = [oizys_user oizys_host];

  poseidon_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEx8KkpRE0VpGp0i3bE/qB1+5vWniibi1Za7k0KOV/f3";
  poseidon_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTMvXrnkyPvxX+cNDm8HG+0X42pkCaqXoITpBEZNFG9";
  poseidon = [poseidon_user poseidon_host];

  semreh_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVho+KHY8MayDm1un32hZUZt6H4SsMTboEwvQzYuf5E";
  semreh_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOczbXpTKp8QZoOI/+5pvLYNXXpC6E2/fyZU32wWaxw6";
  semreh = [semreh_user semreh_host];

in {
  "cloudflared-home.age".publicKeys = semreh;
  # "cloudflared-oracle2.age".publicKeys = semreh; # TODO: use for 2nd Oracle VPS
  "tailscale.age".publicKeys = arete ++ geras ++ maniae ++ oizys ++ poseidon ++ semreh;
  "wakatime.age".publicKeys = arete ++ semreh;
}
