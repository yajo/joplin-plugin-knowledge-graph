{
  description = "Joplin Graph Plugin";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

      perSystem = {pkgs, ...}: {
        devenv.shells.default = {
          # DOCS https://devenv.sh/reference/options/
          languages.javascript.enable = true;
          packages = [
            pkgs.nodePackages.npm-check-updates
          ];
          pre-commit.hooks.alejandra.enable = true;
        };
      };
    };
}
