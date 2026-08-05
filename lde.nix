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
      sha256 = "0z4yxx4z8fm5anrp8b2wvkf4cx9jlslj2k59r15sxszflyhw01b9";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-x86-64.zip";
      sha256 = "03f4y0b5bjf2ychqrikdsjm2p0qdysib7xawkv7skqy2jz11zbvc";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64.zip";
      sha256 = "1s6vzbgpfjwsb5whr1dif0kp8hjxqfyrwvk7nk4rhgiadvzsr7in";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64.zip";
      sha256 = "1nxnqxl4j1q4jxkl8wgb9rwpa4nw6b651gk4rsh02f9b5v00wnj1";
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
