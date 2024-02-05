{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.discord;
  inherit (lib) mkEnableOption mkIf;
in {
  options.programs.discord = {
    enable = mkEnableOption "discord";
    package = lib.mkOption {
      default = pkgs.vesktop;
    };
    finalPackage = lib.mkOption {
      readOnly = true;
      default = cfg.package.overrideAttrs (old: {
        patches = (old.patches or []) ++ [./readonlyFix.patch];
        postFixup = ''
          wrapProgram $out/bin/${cfg.package.meta.mainProgram or (lib.getName cfg.package)} \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      });
    };
  };

  config.hm = mkIf cfg.enable {
    home.packages = [
      cfg.finalPackage
    ];

    xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
      discordBranch = "canary";
      firstLaunch = false;
      arRPC = "on";
      enableMenu = false;
      staticTitle = false;
    };

    xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
      notifyAboutUpdates = false;
      autoUpdate = true;
      autoUpdateNotification = false;
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/llsc12/discord-acrylic/main/Acrylic.theme.css"
        "https://gist.githubusercontent.com/llsc12/16c7067f97867fafde2d2c6c0dd5cd1d/raw/6ac40d6dd75e477117f50e4d757daeb67525f9cb/discord-accent-color.css"
        "https://gist.githubusercontent.com/itsnebulalol/d520d8530e27c194c5359a5b77e9774a/raw/ccaf2ef2775de9df2ccd69b9d6c1b03231eeb93d/discord.css"
      ];
      enabledThemes = [];
      enableReactDevtools = true;
      frameless = false;
      transparent = false;
      winCtrlQ = false;
      macosTranslucency = false;
      disableMinSize = false;
      winNativeTitleBar = false;
      plugins = {
        MessageEventsAPI.enabled = true;
        CommandsAPI.enabled = true;
        MenuItemDeobfuscatorAPI.enabled = true;
        MessagePopoverAPI.enabled = true;
        MessageAccessoriesAPI.enabled = true;
        MessageDecorationsAPI.enabled = true;
        MemberListDecoratorsAPI.enabled = true;
        ServerListAPI.enabled = true;
        FixInbox.enabled = false;
        AlwaysTrust.enabled = false;
        AnonymiseFileNames.enabled = false;
        BANger.enabled = false;
        BetterGifAltText.enabled = false;
        BetterNotesBox.enabled = false;
        BetterRoleDot.enabled = false;
        BetterUploadButton.enabled = false;
        BlurNSFW.enabled = false;
        CallTimer.enabled = false;
        ColorSighted.enabled = false;
        CrashHandler.enabled = false;
        DisableDMCallIdle.enabled = false;
        EmoteCloner.enabled = true;
        Experiments.enabled = true;
        FakeNitro.enabled = false;
        ForceOwnerCrown.enabled = false;
        iLoveSpam.enabled = false;
        IgnoreActivities.enabled = false;
        InvisibleChat.enabled = false;
        LoadingQuotes.enabled = false;
        MemberCount.enabled = false;
        MessageLinkEmbeds.enabled = false;
        MessageLogger.enabled = false;
        MuteNewGuild.enabled = false;
        NoBlockedMessages.enabled = true;
        NoDevtoolsWarning.enabled = false;
        NoF1.enabled = false;
        NoRPC.enabled = false;
        NoReplyMention.enabled = false;
        NoScreensharePreview.enabled = false;
        NoSystemBadge.enabled = false;
        NoUnblockToJump.enabled = true;
        NSFWGateBypass.enabled = false;
        PlainFolderIcon.enabled = false;
        PronounDB.enabled = false;
        RevealAllSpoilers.enabled = false;
        ReverseImageSearch.enabled = false;
        ReviewDB.enabled = false;
        richerCider.enabled = false;
        RoleColorEverywhere.enabled = true;
        ShikiCodeblocks.enabled = false;
        ShowHiddenChannels.enabled = false;
        SilentTyping.enabled = true;
        SortFriendRequests.enabled = false;
        SpotifyControls.enabled = true;
        SpotifyCrack.enabled = true;
        StartupTimings.enabled = false;
        TimeBarAllActivities.enabled = false;
        TypingIndicator.enabled = false;
        TypingTweaks.enabled = true;
        Unindent.enabled = false;
        ReactErrorDecoder.enabled = false;
        VoiceChatDoubleClick.enabled = false;
        ViewIcons.enabled = true;
        VolumeBooster.enabled = false;
        WebContextMenus.enabled = false;
        WhoReacted.enabled = false;
        Settings.enabled = true;
        "WebRichPresence (arRPC)".enabled = true;
        ClearURLs.enabled = true;
        ConsoleShortcuts.enabled = false;
        CorruptMp4s.enabled = false;
        CustomRPC.enabled = false;
        UrbanDictionary.enabled = false;
        Fart2.enabled = false;
        FriendInvites.enabled = false;
        FxTwitter.enabled = false;
        HideAttachments.enabled = false;
        KeepCurrentChannel.enabled = false;
        LastFMRichPresence.enabled = false;
        MessageClickActions.enabled = false;
        MessageTags.enabled = false;
        MoreCommands.enabled = false;
        MoreKaomoji.enabled = false;
        Moyai.enabled = false;
        NoCanaryMessageLinks.enabled = false;
        oneko.enabled = false;
        petpet.enabled = false;
        PlatformIndicators.enabled = false;
        QuickMention.enabled = false;
        QuickReply.enabled = false;
        ReadAllNotificationsButton.enabled = false;
        ServerListIndicators.enabled = false;
        SpotifyShareCommands.enabled = false;
        UwUifier.enabled = false;
        VcNarrator.enabled = false;
        ViewRaw.enabled = false;
        BadgeAPI.enabled = true;
        NoticesAPI.enabled = true;
        NoTrack.enabled = true;
        SupportHelper.enabled = true;
        ContextMenuAPI.enabled = true;
        SilentMessageToggle.enabled = false;
        F8Break.enabled = false;
        SearchReply.enabled = false;
        SettingsStoreAPI.enabled = false;
        BetterFolders.enabled = false;
        FakeProfileThemes.enabled = false;
        GameActivityToggle.enabled = false;
        GifPaste.enabled = false;
        RelationshipNotifier.enabled = false;
        Wikisearch.enabled = false;
        MoreUserTags.enabled = false;
        ImageZoom.enabled = false;
        UserVoiceShow.enabled = false;
        Eggcrypt.enabled = true;
        GreetStickerPicker.enabled = false;
        Meowcrypt.enabled = false;
        AlwaysAnimate.enabled = false;
        PinDMs.enabled = false;
        SendTimestamps.enabled = false;
        ShowMeYourName.enabled = false;
        USRBG.enabled = false;
        DevCompanion.enabled = false;
        PermissionsViewer.enabled = false;
        ShowAllMessageButtons.enabled = false;
        ShowConnections.enabled = true;
        TextReplace.enabled = false;
        Translate.enabled = false;
        ValidUser.enabled = true;
        VencordToolbox.enabled = false;
        BiggerStreamPreview.enabled = false;
        FavoriteEmojiFirst.enabled = false;
        MutualGroupDMs.enabled = false;
        NoPendingCount.enabled = false;
        NoProfileThemes.enabled = false;
        "Party mode 🎉".enabled = false;
        UnsuppressEmbeds.enabled = false;
        OpenInApp.enabled = false;
        FavoriteGifSearch.enabled = false;
        NormalizeMessageLinks.enabled = false;
        PreviewMessage.enabled = false;
        SecretRingToneEnabler.enabled = false;
        VoiceMessages.enabled = false;
        "AI Noise Suppression".enabled = false;
        CopyUserURLs.enabled = false;
        ServerProfile.enabled = false;
        ShowTimeouts.enabled = false;
        ThemeAttributes.enabled = false;
        PictureInPicture.enabled = false;
        Dearrow.enabled = false;
        FixSpotifyEmbeds.enabled = false;
        OnePingPerDM.enabled = false;
        PermissionFreeWill.enabled = false;
        NoMosaic.enabled = false;
        NoTypingAnimation.enabled = true;
        WebKeybinds.enabled = true;
        ClientTheme.enabled = false;
        FixImagesQuality.enabled = false;
        SuperReactionTweaks.enabled = true;
        Decor.enabled = false;
        NotificationVolume.enabled = false;
        BetterGifPicker.enabled = false;
        FixCodeblockGap.enabled = false;
      };
      notifications = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "never";
        logLimit = 50;
      };
      cloud = {
        authenticated = false;
        url = "https://api.vencord.dev/";
        settingsSync = false;
        settingsSyncVersion = 1707086786031;
      };
    };
  };
}
