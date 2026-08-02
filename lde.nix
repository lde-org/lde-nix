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
      sha256 = "055mb7rgilwxqkhvcd27fjkva8a7gv7d6rwf2a91in05i1lp2jg3";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-macos-x86-64";
      sha256 = "1y1i7a68gsmj0hkk2gliw1f4z20hfgql7ihs9kj7wfijj3ylfc87";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64";
      sha256 = "1fryz6i8ixg4bfx88abl09r9a83hpmcjgl1bypwasygx8zfmlpgf";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64";
      sha256 = "1hdmf77pz49vqmh8hqb579r7v16ppc2i0iyjx3j5i5wlcy1x2y8l";
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
