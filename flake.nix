# flake.nix
{
  description = "syaofox's DWM rice for NixOS – startx, no patches";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      mkPkgSet =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # 直接编译本地源码
          dwm = pkgs.stdenv.mkDerivation {
            pname = "dwm";
            version = "6.4";
            src = ./src/dwm;
            buildInputs = with pkgs; [ libX11 libXinerama libXft ];
            makeFlags = [ "PREFIX=$(out)" ];
          };

          slstatus = pkgs.stdenv.mkDerivation {
            pname = "slstatus";
            version = "1";
            src = ./src/slstatus;
            buildInputs = with pkgs; [ libX11 ];
            makeFlags = [ "PREFIX=$(out)" ];
          };

          slock = pkgs.stdenv.mkDerivation {
            pname = "slock";
            version = "1.5";
            src = ./src/slock;
            buildInputs = with pkgs; [ libX11 libXinerama libXft ];
            makeFlags = [ "PREFIX=$(out)" ];
          };
        in {
          inherit pkgs dwm slstatus slock;
        };

      perSystem =
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgSet = mkPkgSet system;
          in {
            packages = {
              inherit (pkgSet) dwm slstatus slock;
            };
          }
        );

      nixSystem = "x86_64-linux";
      nixPkgSet = mkPkgSet nixSystem;
    in
    perSystem // {
      nixosConfigurations.nix3060 = nixpkgs.lib.nixosSystem {
        system = nixSystem;
        modules = [
          /etc/nixos/hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.syaofox = import ./home.nix {
              inherit (nixPkgSet) pkgs dwm slstatus slock;
            };
          }
        ];
      };

      templates.default = {
        path = ./.;
        description = "syaofox DWM NixOS rice (startx, no DM)";
      };
    };
}