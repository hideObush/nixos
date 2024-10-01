{inputs, config, pkgs, outputs,... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hjkl";

  gtk.enable = true;
  qt.enable = true;

  programs.git = {
    enable = true;
    userName = "Vetoes";
    userEmail = "jsaiomay123@gmail.com";
  };

  home.sessionVariables = {
	# EDITOR="nvim";
	# CHECK="FD";


    # EDITOR = "emacs";
  };

  nixpkgs = {
    overlays = [
    # (import ./overlays)
      # outputs.overlays.unstable-packages
      # sddm-sugar-candy-nix.overlays.default
    ];
  };


  home.packages = [
    pkgs.hello
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.bemenu
    pkgs.unzip
    pkgs.swww

    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.typescript-language-server


    pkgs.kdePackages.plasma-workspace
    pkgs.glib
    pkgs.libsForQt5.kconfig

    pkgs.font-awesome

    pkgs.fira-code-nerdfont
    pkgs.jq
  ];

  home.file = {

  };

  imports = [
    # inputs.ags.homeManagerModules.default
    # sddm-sugar-candy-nix.nisosModules.default
    ./apps
   ./system
   ./desktop
   # ./neovim
   # ./overlays
  ];

  # compiler.enable = true;
  apps.enable = true;
  system.enable = true;
  desktop.enable = true;
  

  # Let Home Manager install and manage itself.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;


}
