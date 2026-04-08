{
  pkgs ? import <nixpkgs> { },
  system ? builtins.currentSystem,
}:

let
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "v0.9.0";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.0/lde-macos-aarch64";
      sha256 = "11h4pbzjvv255i5bbsh38fy14ix6lna26y5sbnnkzh6sixrq2p30";
    };
    "aarch64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.0/lde-linux-aarch64";
      sha256 = "1mybs93g1gjvkz70vqwk4nxn4lav9smpginp5dw79g6qcrvm533c";
    };
    "x86_64-linux" = {
      url = "https://github.com/lde-org/lde/releases/download/v0.9.0/lde-linux-x86-64";
      sha256 = "0sjriwcvv9436vgmx9lbmip9mq0fhz10452li95ns6xl2ph1iw01";
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
