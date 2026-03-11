{
    description = "FastAPI dev environment (Nixpkgs only)";

    inputs = {
        nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs =
        {
            self,
            nixpkgs,
            flake-utils,
        }:
        flake-utils.lib.eachDefaultSystem (
            system:
            let
                pkgs = import nixpkgs { inherit system; };

                pythonEnv = pkgs.python3.withPackages (
                    ps: with ps; [
                        django
                        django-ninja
                        pywebpush
                        py-vapid
                        django-cors-headers
                        django-stubs
                    ]
                );
            in
            {
                devShells.default = pkgs.mkShell {
                    packages = [
                        pythonEnv
                        pkgs.nodejs_24
                        pkgs.nodePackages.pnpm
                    ];

                    shellHook = ''
                        export NIX_SHELL_NAME='kallan'
                        ln -sfn ${pythonEnv} .venv
                    '';
                };
            }
        );
}
