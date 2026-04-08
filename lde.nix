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
      sha256 = "0nhi7sqzak8c38awgcll774a0syl1mwdb598c57a562j2sqyjgfl";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-aarch64";
      sha256 = "0h3v3wjjqcd7kqnv3ss6m0h48jmhrmvxfsz3v7v9yl7apsicdll6";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/nightly/lde-linux-x86-64";
      sha256 = "1a0mb3s87lrnyn8n5426rzqpq3q4yszmryxwcsx12abwr7rr9gf2";
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
