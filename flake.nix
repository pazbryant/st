{
  description = "snazzy terminal (suckless + lightweight)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          st-bryant-light = pkgs.callPackage ./default.nix { };
        };
        defaultPackage = packages.st-bryant-light;
        apps.st-bryant-light = flake-utils.lib.mkApp {
          drv = packages.st-bryant-light;
          exePath = "/bin/st-light";
        };
        apps.default = apps.st-bryant-light;
        defaultApp = apps.st-bryant-light;
        devShell = pkgs.mkShell rec {
          name = "st-bryant-light";
          packages = with pkgs; [
            pkgconfig
            xorg.libX11
            xorg.libXft
            fontconfig
            harfbuzz
            gd
            glib
          ];
        };

      });
}
