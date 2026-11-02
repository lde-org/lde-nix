{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "nightly";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-aarch64.zip";
      sha256 = "0cx4fh455gf1pmi825cqg4a7hj3dhc144wv7zw26xs20nxgp426c";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-x86-64.zip";
      sha256 = "1sxhndki855krj1ximzhivlyxw96mncvnh514bvpidhjxm5zm5ys";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64.zip";
      sha256 = "0rh1zw9xd1qfk78hwcvwncz832qyzfaf6zskls0cvc89qpsax5n5";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64.zip";
      sha256 = "0rpyixyiaijjmq0rda36q3dzxf7d5kymy13a44f2b1r81chr3mhq";
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
    unzip
  ];
  buildInputs = with pkgs; [
    glibc
    gcc-unwrapped
    openssl
    zlib
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip "$src"
    mv "$(basename ${platform_attrs.${system}.url} .zip)" lde
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -D lde "$out/bin/lde"
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
