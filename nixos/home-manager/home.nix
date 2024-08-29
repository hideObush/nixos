{ config, pkgs,outputs,... }:

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



  home.packages = [
    pkgs.hello
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.unzip
    pkgs.swww


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
  ];

  # nixpkgs = {
  #   overlays = [
  #     outputs.overlays.unstable-packages
  #     # sddm-sugar-candy-nix.overlays.default
  #   ];
  # };
  # compiler.enable = true;
  apps.enable = true;
  system.enable = true;
  desktop.enable = true;
  

  # Let Home Manager install and manage itself.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;


}
