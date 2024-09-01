{
  description = "snazzy terminal (suckless + lightweight)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          st-bryant = pkgs.callPackage ./default.nix { };
        };
        defaultPackage = packages.st-bryant;
        apps.st-bryant = flake-utils.lib.mkApp {
          drv = packages.st-bryant;
          exePath = "/bin/st";
        };
        apps.default = apps.st-bryant;
        defaultApp = apps.st-bryant;
        devShell = pkgs.mkShell rec {
          name = "st-bryant";
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
