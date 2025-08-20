{ pkgs, src }:

pkgs.stdenv.mkDerivation {
  pname = "audacis-blog";
  version = "2024-11-09";
  inherit src;
  nativeBuildInputs = [ pkgs.zola ];
  buildPhase = ''
    zola build
  '';
  installPhase = ''
    mkdir -p $out
    cp -r public/* $out/
  '';
}