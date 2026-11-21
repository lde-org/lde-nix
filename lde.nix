{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.11.2";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.2/lde-macos-aarch64.zip";
      sha256 = "0rcv5mddkix5865jm1a07ac82hk65nwcqx8kqqi65z1pbr7ms1m8";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.2/lde-macos-x86-64.zip";
      sha256 = "0cma52jnyakd6djnn1d7nkm4bg30l84cgwphfr807igk0991z15c";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.2/lde-linux-aarch64.zip";
      sha256 = "1yhchgh9aknap4qb4i9cqh7n5hi0x5dp3q6xnjiyy7pw15gcjzil";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.11.2/lde-linux-x86-64.zip";
      sha256 = "1jn1bclq8k65q1dbcpg2qmchi7a3irbplpyigvjf9a8nqspxxhyr";
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
