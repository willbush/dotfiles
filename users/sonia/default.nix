{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in {
  imports = [ ../../profiles/common/fonts.nix ];
  # TODO deal with syncthing hard-coding home paths
  # imports = [ ../../fonts.nix ../../modules/services/syncthing.nix ];

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = fileContents ../../secrets/hashed-password-root.txt;

      sonia = {
        uid = 1001;
        isNormalUser = true;
        home = "/home/sonia";
        hashedPassword = fileContents ../../secrets/hashed-password-sonia.txt;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" ];
      };
    };
  };

  home-manager = {
    users.sonia = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    # Required until nix version 2.4 for nix flakes
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    autoOptimiseStore = true;
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hercules-ci.cachix.org"
      "https://iohk.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-tools.cachix.org"
      "https://nixcache.reflex-frp.org"
      "https://willbush.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-tools.cachix.org-1:ebBEBZLogLxcCvipq2MTvuHlP7ZRdkazFSQsbs0Px1A="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "willbush.cachix.org-1:PuQjKarzPYTnxgEzKUoTDQ+aN0SImhO8NMZ0CamKBL4="
    ];
    gc = {
      automatic = true;
      dates = "23:00";
      options = "--delete-older-than 30d";
    };
  };

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };

  # TODO
  # modules.services.syncthing.enable = true;

  # TODO
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.xserver = {
  #   enable = true;
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma5.enable = true;
  # };

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [ pkgs.hll2390dw-cups ];

    xserver = {
      enable = true;
      layout = "us";

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackges: [
          haskellPackges.xmonad-contrib
          haskellPackges.xmonad-extras
          haskellPackges.xmonad
        ];
      };

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = true;
      };
      desktopManager.xterm.enable = false;
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    curl
    fd
    neovim
    ripgrep
    tree
    wget
  ];

  programs = {
    ssh.startAgent = true;
    # needed for gnome / gtk themes
    dconf.enable = true;
    qt5ct.enable = true;
    gnupg.agent.enable = true;
    less.enable = true;
  };

  system.stateVersion = "20.09";
}