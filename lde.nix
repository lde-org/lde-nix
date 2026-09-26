{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.11.1";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.1/lde-macos-aarch64.zip";
      sha256 = "128plhr9f51816wr1rwvbc29pkwk625r81563njh3d3n4svczz8f";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.1/lde-macos-x86-64.zip";
      sha256 = "1s7fxd9mvhj6hki9fdnwlw2f4vfmikbya4lgpvpc1q4k54nmwgwp";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.1/lde-linux-aarch64.zip";
      sha256 = "0ljzhypjpr1ghysk27vhkc3zrr4ipwkw3zfa99rw4667sph5dhj6";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.1/lde-linux-x86-64.zip";
      sha256 = "0a59hmbjckzdwp6mbv3qvrwbl4caxkdqw5sfwxl5x96hy1q13dpw";
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
