{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.10.0";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-macos-aarch64.zip";
      sha256 = "14w46liqczwqnm33hq8rq3937473b6y5hj8cn1pryifiqbydajm6";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-macos-x86-64.zip";
      sha256 = "0r7qwx0mmgz9d5fy5qsj0a5a6jzxi8b5k5la5wxl8n600jrbff2z";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-linux-aarch64.zip";
      sha256 = "1p52vdghi5im7iz89ccw2rvaig8bmr4ajvwsylkm6bww0airpirl";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-linux-x86-64.zip";
      sha256 = "1y3qkdd18hk9k1rfhrx9w28w1dr5ifw7kzlssyd5d950bhbq3ca4";
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
