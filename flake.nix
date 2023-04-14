{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        isDarwin = pkgs.lib.hasSuffix "darwin" system;
      in
      {
        devShells.default =
          pkgs.mkShell {
            packages = [ pkgs.protobuf pkgs.llvm pkgs.rustup pkgs.rustc ];
            buildInputs = with pkgs; [ libclang ];
            LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

            BINDGEN_EXTRA_CLANG_ARGS = with pkgs;
              "-isystem ${libclang.lib}/lib/clang/${lib.getVersion libclang}/include";
            shellHook = ''
              rustup install 1.68.0
              rustup default 1.68.0

              rustup toolchain install nightly-2023-01-30
              rustup target add wasm32-unknown-unknown --toolchain nightly-2023-01-30
              rustup override set nightly-2023-01-30
            '';
          };
      });
}
