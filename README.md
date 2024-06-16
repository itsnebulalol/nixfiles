# Nebula's NixOS config flake

## Hosts

- Consus (Dell PowerEdge 2900)
- Geras (Dell Inspiron as a Server)
- Maniae (Oracle Cloud 3)
- Oizys (Oracle Cloud 1)
- Poseidon (Oracle Cloud 2 - Media Server)
- Semreh (Raspberry Pi 4)

## Modules

### Programs

- Git
- nh
- Neovim
- zsh

### Services

- AdGuard Home (+ adguardhome-sync)
- Caddy
- Caddy Internal
- Conduit
- Docker
- Homepage
- Instafix
- Monero
- Media Server
  - Annatar
  - Blackhole
  - Jellyfin (+ Jellyseerr)
  - Notifiarr
  - Plex (+ Overseerr)
  - Prowlarr
  - Radarr (Normal, 4K, 4K DV, Extra)
  - RDTClient
  - Sonarr (Normal, 4K, 4K DV, Extra)
  - Tautulli
  - Zurg
- nostr-rs-relay
- Samba
- Scrypted
- Soulseek
- SSH
- Static
- Tailscale
- Watchtower
- WireGuard Server

## Credits

- [ne3oney/nixus](https://github.com/n3oney/nixus)
- [nikitawootten/infra](https://github.com/nikitawootten/infra)
