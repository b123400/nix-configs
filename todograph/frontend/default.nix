{ src }:

let pkgs = import <nixpkgs> {};
    spagoPkgs = import ./spago-packages.nix { inherit pkgs; };

    easyPS = import (pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "647b28018c348832e47a0f17aa0994f0e4c1e5b5"; # This is the last commit for Purescript 0.12.3
      sha256 = "0r6jvq64fbfyw8acl7xcfm0wsq1n52jbx6a2s31fdgk5hg30ch8f";
    });
    frontendSrc = "${src}/frontend/";
    projectOut = spagoPkgs.mkBuildProjectOutput {
      src = frontendSrc;
      purs = easyPS.purs;
    };
in
pkgs.stdenv.mkDerivation rec {
  name = "todograph";
  version = "v1.0.0";
  src = frontendSrc;
  buildInputs = [ easyPS.purs ];
  buildPhase =
  ''
    purs bundle '${projectOut}/output/**/*.js' -m Main --main Main -o ./bundle.js
  '';
  installPhase = ''
    mkdir -p $out
    mv ./bundle.js $out
  '';
}
