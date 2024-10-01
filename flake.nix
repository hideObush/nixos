# flake.nix
{
  description = "A simple NixOS flake";

  inputs = {
# NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    aquamarine = {
      type = "git";
      url = "https://github.com/hyprwm/aquamarine";
      ref = "refs/tags/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      ref = "refs/tags/v0.43.0";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.aquamarine.follows = "aquamarine";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };


    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };	

    xremap-flake.url = "github:xremap/nix-flake";
    ags.url = "github:Aylur/ags";

    stylix.url = "github:danth/stylix/";
    stylix.inputs.nixpkgs.follows ="nixpkgs-unstable";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";

      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs,nixpkgs-unstable,home-manager,stylix,...}@inputs:
    let

    inherit(self) outputs;

  system = "x86-64-linux";
  forAllSystems =nixpkgs.lib.genAttrs system;
  pkgs = import nixpkgs {

    inherit  system;

    config = {
      allowUnfree = true;
    };
  };

  in
  {

    overlays = import ./overlays {inherit inputs outputs;};

    nixosConfigurations = {
      scv = nixpkgs.lib.nixosSystem {

      specialArgs={inherit  outputs inputs system ;};



      modules = [
        ./hosts/scv/configuration.nix    
          # stylix.nixosModules.stylix ./hosts/scv/configuration.nix

        home-manager.nixosModules.default
        home-manager.nixosModules.home-manager{
          home-manager.useGlobalPkgs =true;
          home-manager.useUserPackages = true;
          home-manager.users.hjkl = import ./home-manager/home.nix;
        }
      ];
    };
    };
  };
}
