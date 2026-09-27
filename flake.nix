{
  description = "A flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    unsareport.url = "github:UNSAReport/UNSAReport2?ref=dev";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      unsareport,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        fonts = with pkgs; [
          carlito
        ];
        shellPkgs = pkgs.lib.flatten [
          (with pkgs; [
            bun
          ])
          (with unstable; [
            typst
            typstyle
          ])
          fonts
          unsareport.packages.${system}.default
        ];
        ldPkgs = with pkgs; [
          stdenv.cc.cc
          zlib
          glib
          libxcb
          libglvnd
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ldPkgs;
          packages = pkgs.lib.flatten [
            shellPkgs
          ];
          shellHook = "";
          env = {
            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = fonts;
            };
          };
          buildInputs = [ pkgs.bashInteractive ];
        };
      }
    );
}
