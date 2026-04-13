{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.9.1";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.1/lde-macos-aarch64";
      sha256 = "1p34f7wcahhcyx3ag465k4wyf5qys3a203dqzrgbl81gg8amjb5z";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.1/lde-linux-aarch64";
      sha256 = "1xamm1k48r5kgpkr1k5q814ksj82r6c3jrj51ir0qkd7c1b9yw2a";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.1/lde-linux-x86-64";
      sha256 = "1yhcx45fx022wpvg5vkvpgzlg7rbiiambza6373fqrxzfhx941qr";
    };
  };
  # GENERATED VERSION CONTROL - END
in
pkgs.stdenv.mkDerivation {
  pname = "lde";
  version = releaseTag;
  src = pkgs.fetchurl platform_attrs.${system};
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [
    pkgs.glibc
    pkgs.gcc-unwrapped
  ];
  unpackPhase = "true";
  installPhase = ''
    install -D "$src" "$out/bin/lde"
  '';
}
