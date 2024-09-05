# flake.nix
{
  description = "A simple NixOS flake";

  inputs = {
# NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";


    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };	

    xremap-flake.url = "github:xremap/nix-flake";
    ags.url = "github:Aylur/ags";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";

      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs,nixpkgs-unstable,home-manager, ... }@inputs:
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

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations.scv = nixpkgs.lib.nixosSystem {

      specialArgs={inherit  outputs inputs system;};



      modules = [
        ./hosts/scv/configuration.nix    
        home-manager.nixosModules.default
      ];
    };
  };
}
