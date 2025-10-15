{
  description = "Simple program in Epos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    epos.url = "github:epos-lang/epos";
  };

  outputs = { self, nixpkgs, flake-utils, epos }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "simple-epos-app";
            version = "0.0.1";

            unpackPhase = "true";

            installPhase = ''
              mkdir -p $out/bin
              ${epos.packages.${system}.default}/bin/epos ${
                ./main.epos
              } -o $out/bin/main
            '';
          };
        };
        devShells.default =
          pkgs.mkShell { buildInputs = [ epos.packages.${system}.default ]; };
      });
}
