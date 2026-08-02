{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "nightly";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-aarch64";
      sha256 = "1w8m3943cczsiplp5iib9bz8q758zda3zc3j3pddr3z20y9dip68";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.1/lde-macos-x86-64";
      sha256 = "0112p44mjwdpn4k57adl2rspvw8l5qi5sr763sgj4hhxnbqmazc7";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64";
      sha256 = "1qs06in1sak3rczh3y74598kxgdwwhyjghc4qcrrp4379lhnh4am";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64";
      sha256 = "0vfnk0j9kllmk00fi0225avg4sjf5rpxnvpjb5d8c8xm3xa3fm57";
    };
  };
  # GENERATED VERSION CONTROL - END
in
pkgs.stdenv.mkDerivation {
  pname = "lde";
  version = releaseTag;
  src = pkgs.fetchurl platform_attrs.${system};
  nativeBuildInputs = with pkgs; [
    pkg-config
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = with pkgs; [
    glibc
    gcc-unwrapped
    openssl
    zlib
  ];
  unpackPhase = "true";

  installPhase = ''
    install -D "$src" "$out/bin/lde"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/lde" \
      --prefix LD_LIBRARY_PATH : ${
        pkgs.lib.makeLibraryPath (
          with pkgs;
          [
            openssl
            zlib
          ]
        )
      }
  '';
}
