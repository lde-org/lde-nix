{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.10.0";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-macos-aarch64";
      sha256 = "1xcbnc1mb0fmlg9767zzwpc7fv9i2vy2xvr9n3wan6k0bdfhkbmv";
    };
    "x86_64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-macos-x86-64";
      sha256 = "14y3ifpzdj7ivflihscy3mcdi97im8mssbmv2pcwq012bdpynpgk";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-linux-aarch64";
      sha256 = "1dwwgz84217xkk4089l6brz990rq8qj95lw78530i4p4vm62xyxg";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.10.0/lde-linux-x86-64";
      sha256 = "1q1rzh9n4rxfb6zdpdsgniza3n1ibcf8j0vmkjzfxk6xnchmhwny";
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
