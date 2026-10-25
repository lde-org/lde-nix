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
      sha256 = "09xmvzbryjvgk2cp4jxwjb0yrm3pmr3nr167c8vdx787b3g2y8dj";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-x86-64.zip";
      sha256 = "0d3665gaiimyhmg635d9ifl0ypd38mk9b90v7jwbskpicrml637b";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64.zip";
      sha256 = "0k7y15zps2jfj3b1dp5a015qh38apql9i3gajn02n2fy025c5wna";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64.zip";
      sha256 = "1s38cspp93w7vm5dh7a4q5x3cz217cmqml0brdkf6d79m65g46rl";
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
