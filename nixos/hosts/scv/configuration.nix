# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ outputs,config, pkgs,inputs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
			inputs.xremap-flake.nixosModules.default
			inputs.home-manager.nixosModules.default
		];

	
	services.xremap = {
		withWlroots  = true;
		userName = "hjkl";
		config = {
			modmap = [
			{
				name= "caps to escape";
				remap = {"CapsLock" = "Esc";};
			}
			];


		};
	};
services.displayManager.sddm.wayland.enable = true;
services.displayManager.sddm.enable = true;
boot.loader.grub.device =  "nodev" ;
boot.loader.grub.efiSupport = true;
# boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
time.hardwareClockInLocalTime = true;

# hyprland 
	programs = {
		hyprland = {
			enable = true;
		};

		xwayland = {
			enable =true;
		};
#fish
		fish.enable = true;
		neovim ={
			enable =  true;
			package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
		};


	};
	services.xserver.videoDrivers=["nvidia"];



# nvidia
	hardware = {

		opengl = {
			enable = true;
		};
		nvidia = {
			modesetting.enable = true;
			open = false;
			nvidiaSettings = true;
			package =  config.boot.kernelPackages.nvidiaPackages.stable;
			forceFullCompositionPipeline =true;
			powerManagement.enable = false;
		};
		pulseaudio.enable =true;
	};


	networking.hostName = "scv"; # Define your hostname.

# Enable networking
		networking.networkmanager.enable = true;

# Set your time zone.
	time.timeZone = "Asia/Seoul";

# Select internationalisation properties.
 i18n.inputMethod = {
   enabled ="fcitx5";
   fcitx5.waylandFrontend = true;

   fcitx5.addons = with pkgs;[
   fcitx5-hangul
   fcitx5-gtk
   ];
 };
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "ko_KR.UTF-8";
		LC_IDENTIFICATION = "ko_KR.UTF-8";
		LC_MEASUREMENT = "ko_KR.UTF-8";
		LC_MONETARY = "ko_KR.UTF-8";
		LC_NAME = "ko_KR.UTF-8";
		LC_NUMERIC = "ko_KR.UTF-8";
		LC_PAPER = "ko_KR.UTF-8";
		LC_TELEPHONE = "ko_KR.UTF-8";
		LC_TIME = "ko_KR.UTF-8";
	};

# Configure keymap in X11
# services.xserver.displayManager.sddm.enable = true;
	services.xserver = {
		xkb.layout = "us";
		xkb.variant = "";
	};

# Define a user account. Don't forget to set a password with ‘passwd’.

	users.users.hjkl = {
		isNormalUser = true;
#    isSystemUser = true;
		shell = pkgs.fish;  

		description = "hjkl";
		extraGroups = ["audio" "networkmanager" "wheel" ];

		packages = with pkgs; [
				fish
				git
				alacritty
				firefox
        microsoft-edge
		];
	};


	 home-manager = {
	 	extraSpecialArgs = {inherit inputs;};
	 	users = {
	 		hjkl = import ../../home-manager/home.nix;
	 	};
	 };

	nix.settings.experimental-features = [ "nix-command"  "flakes" ];

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.pulseaudio=true;
  nixpkgs = { 

  overlays = [
    # outputs.overlays.additions
    outputs.overlays.unstable-packages
  ];

  };
	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
			lf

	];
	system.stateVersion = "24.05"; # Did you read the comment?

}
