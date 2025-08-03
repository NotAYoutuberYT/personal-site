{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    {
      nixosModules.default = import ./module.nix;
    }
    // flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        treefmt-eval = treefmt-nix.lib.evalModule pkgs {
          programs.nixfmt.enable = true;
          programs.statix.enable = true;
          programs.deadnix.enable = true;
          programs.prettier.enable = true;
        };
      in
      {
        formatter.${system} = treefmt-eval.config.build.wrapper;

        devShells.${system}.default = pkgs.mkShell {
          packages = [
            pkgs.just
            pkgs.http-server
          ];
        };
      }
    );
}
