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
      sha256 = "1s6sic6zg9lcpv5858x1jd91l491r17yb86qb2am9r809lpa7w18";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64";
      sha256 = "05diii05r98g2f6scg1w2l5iignk5w3kbl9b6nb26zm1r0rds6db";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64";
      sha256 = "0f2ckj8cxvvdq0qs93h81y67pr4kr3nzdzy24lzxqly07kbm6mdg";
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
