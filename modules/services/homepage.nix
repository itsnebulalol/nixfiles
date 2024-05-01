{
  config,
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  options.services.homepage.enable = lib.mkEnableOption "Homepage";

  config = lib.mkIf config.services.homepage.enable {
    services.caddy-internal.enable = true;

    os = {
      services.homepage-dashboard = {
        enable = true;
        openFirewall = true;
        envrionmentFile = osConfig.age.secrets.homepage_env.path;
        docker = {
          # TODO: Figure out how to use docker socket proxy over tailscale
        };
        services = [
          {
            Streaming = [
              {
                Plex = {
                  icon = "plex.svg";
                  href = "https://plex.itsnebula.net";
                  description = "family media server";
                  widget = {
                    type = "plex";
                    url = "http://poseidon.coin-gray.ts.net:32400";
                    key = "{{HOMEPAGE_VAR_PLEX_TOKEN}}";
                    fields = ["streams" "movies" "tv"];
                  };
                };
              }
              {
                Overseerr = {
                  icon = "overseerr.svg";
                  href = "https://requests.itsnebula.net";
                  description = "plex requests";
                  widget = {
                    type = "overseerr";
                    url = "https://requests.itsnebula.net";
                    key = "{{HOMEPAGE_VAR_OVERSEERR_API_KEY}}";
                    fields = ["available" "processing"];
                  };
                };
              }
              {
                Jellyfin = {
                  icon = "jellyfin.svg";
                  href = "https://jellyfin.itsnebula.net";
                  description = "media server";
                  widget = {
                    type = "jellyfin";
                    url = "https://jellyfin.itsnebula.net";
                    key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                    fields = ["movies" "series" "episodes"];
                    enableBlocks = true;
                    enableNowPlaying = false;
                  };
                };
              }
              {
                Jellyseerr = {
                  icon = "jellyseerr.svg";
                  href = "https://privaterequests.itsnebula.net";
                  description = "jellyfin requests";
                  widget = {
                    type = "jellyseerr";
                    url = "https://privaterequests.itsnebula.net";
                    key = "{{HOMEPAGE_VAR_JELLYSEERR_API_KEY}}";
                    fields = ["available" "processing"];
                  };
                };
              }
            ];
          }
          {
            Downloaders = [
              {
                Radarr = {
                  icon = "radarr.svg";
                  href = "https://radarr.ms.itsnebula.net";
                  description = "movie downloader";
                  widget = {
                    type = "radarr";
                    url = "http://poseidon.coin-gray.ts.net:9003";
                    key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                  };
                };
              }
              {
                "Radarr 4K" = {
                  icon = "radarr.svg";
                  href = "https://radarr4k.ms.itsnebula.net";
                  description = "4k movie downloader";
                  widget = {
                    type = "radarr";
                    url = "http://poseidon.coin-gray.ts.net:9103";
                    key = "{{HOMEPAGE_VAR_RADARR4K_API_KEY}}";
                  };
                };
              }
              {
                "Radarr 4K DV" = {
                  icon = "radarr.svg";
                  href = "https://radarr4kdv.ms.itsnebula.net";
                  description = "4k dolby vision movie downloader";
                  widget = {
                    type = "radarr";
                    url = "http://poseidon.coin-gray.ts.net:9203";
                    key = "{{HOMEPAGE_VAR_RADARR4KDV_API_KEY}}";
                  };
                };
              }
              {
                "Radarr Extra" = {
                  icon = "radarr.svg";
                  href = "https://radarrextra.ms.itsnebula.net";
                  description = "extra movie downloader";
                  widget = {
                    type = "radarr";
                    url = "http://poseidon.coin-gray.ts.net:9303";
                    key = "{{HOMEPAGE_VAR_RADARREXTRA_API_KEY}}";
                  };
                };
              }
              {
                Sonarr = {
                  icon = "sonarr.svg";
                  href = "https://sonarr.ms.itsnebula.net";
                  description = "TV downloader";
                  widget = {
                    type = "sonarr";
                    url = "http://poseidon.coin-gray.ts.net:9004";
                    key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                  };
                };
              }
              {
                "Sonarr 4K" = {
                  icon = "sonarr.svg";
                  href = "https://sonarr4k.ms.itsnebula.net";
                  description = "4k TV downloader";
                  widget = {
                    type = "sonarr";
                    url = "http://poseidon.coin-gray.ts.net:9104";
                    key = "{{HOMEPAGE_VAR_SONARR4K_API_KEY}}";
                  };
                };
              }
              {
                "Sonarr 4K DV" = {
                  icon = "sonarr.svg";
                  href = "https://sonarr4kdv.ms.itsnebula.net";
                  description = "4k dolby vision TV downloader";
                  widget = {
                    type = "sonarr";
                    url = "http://poseidon.coin-gray.ts.net:9204";
                    key = "{{HOMEPAGE_VAR_SONARR4KDV_API_KEY}}";
                  };
                };
              }
              {
                "Sonarr Extra" = {
                  icon = "sonarr.svg";
                  href = "https://sonarrextra.ms.itsnebula.net";
                  description = "extra TV downloader";
                  widget = {
                    type = "sonarr";
                    url = "http://poseidon.coin-gray.ts.net:9304";
                    key = "{{HOMEPAGE_VAR_SONARREXTRA_API_KEY}}";
                  };
                };
              }
            ];
          }
          {
            Files = [
              {
                RDTClient = {
                  icon = "rdt-client.svg";
                  href = "http://media.coin-gray.ts.net:9001";
                  description = "real-debrid downloader";
                  server = "docker-local";
                  container = "rdtclient";
                };
              }
              {
                Prowlarr = {
                  icon = "prowlarr.svg";
                  href = "http://media.coin-gray.ts.net:9002";
                  description = "torrent indexer";
                  server = "docker-local";
                  container = "prowlarr";
                  widget = {
                    type = "prowlarr";
                    url = "http://media.coin-gray.ts.net:9002";
                    key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
                    fields = [
                      "numberOfGrabs"
                      "numberOfQueries"
                    ];
                  };
                };
              }
            ];
          }
        ];
        settings = {
          title = "Home";
          background = {
            image = "https://images.unsplash.com/photo-1502759166908-21d2a2ddc2d5?auto=format&fit=crop&w=2560&q=80";
            blur = "sm";
            saturate = 50;
            brightness = 50;
            opacity = 50;
            cardBlur = "3xl";
          };
          theme = "dark";
          useEqualHeights = true;
          hideVersion = true;
          statusStyle = "dot";
          layout = {
            Streaming = {
              style = "row";
              columns = 4;
            };
            Downloaders = {
              style = "row";
              columns = 4;
            };
          };
          providers = {
            openweathermap = "openweathermapapikey";
            weatherapi = "weatherapiapikey";
          };
        };
        widgets = [
          {
            resources = {
              cpu = true;
              memory = true;
              disk = "/";
            };
          }
          {
            datetime = {
              text_size = "xl";
              format = {
                timeStyle = "short";
              };
            };
          }
        ];
      };

      services.caddy = {
        enable = true;
        virtualHosts = {
          "home.itsnebula.net".extraConfig = ''
            reverse_proxy 127.0.0.1:8082
            import cloudflare
          '';
        };
      };
    };
  };
}