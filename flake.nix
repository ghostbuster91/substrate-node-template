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
            packages = with pkgs; [ protobuf llvm rust ];
            # buildInputs = with pkgs; [ libclang ];
            LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
            HOST_CXXFLAGS =
              if isDarwin
              then "-I ${pkgs.darwin.apple_sdk.CLTools_Executables}/usr/include/c++/v1 -I ${pkgs.darwin.apple_sdk.CLTools_Executables}/usr/include"
              else "";
            BINDGEN_EXTRA_CLANG_ARGS = with pkgs;
              "-isystem ${libclang.lib}/lib/clang/${lib.getVersion libclang}/include";
          };
      });
}
