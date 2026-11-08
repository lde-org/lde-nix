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
      sha256 = "1sn653bfnpza44y7skqrm2wpzzv1v5rfvamgjhaxpqw1p9ggi66q";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-x86-64.zip";
      sha256 = "0m935j3v2ca787q3626gr5sli57j7afqvw0bh96agk2hl8x5gsl9";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64.zip";
      sha256 = "0m868lp25a9w124van1nik64nj0vsagzbdk6hf07v2jnshd28s68";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64.zip";
      sha256 = "1kq1vjs7z1ziapz74a56mvwrn33gxphdmqbz1iyrwv5hc0x6k1zc";
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
