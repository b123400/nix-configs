{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  nodejs ? pkgs."nodejs-8_x",
  src,
}:

let
  nodeEnv = (import ./package.nix { inherit system pkgs nodejs; }).package;
  styleSrc = "${src}/style";
in
pkgs.stdenv.mkDerivation rec {
  name = "todograph-style";
  version = "v1.0.0";
  src = styleSrc;
  buildInputs = [ nodeEnv ];
  BASE_DIR="${nodeEnv}/lib/node_modules/todograph/";
  buildPhase =
  ''
    echo ${nodeEnv}
    mkdir -p $out
    $BASE_DIR/node_modules/.bin/stylus ${styleSrc}/index.styl -o ./index.css
  '';
  installPhase = ''
    mkdir -p $out
    cp ./index.css $out
  '';
}
