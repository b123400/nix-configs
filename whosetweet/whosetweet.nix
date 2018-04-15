with (import <nixpkgs> {});

{ stdenv,
  fetchgit,
  makeWrapper,
  stack }:

let
  ghc = haskell.compiler.ghc7103;
in
haskell.lib.buildStackProject {
  name = "whosetweet";
  buildInputs = [ zlib stack makeWrapper ghc ];
  ghc = ghc;
  src = fetchgit {
    url = git://github.com/b123400/whosetweet;
    rev = "30c00d09ce31d07b5828f818dc20fecf82c7c33b";
    sha256 = "16wahwfg13cynqhfv6j8l4b0lyncqsrr638dm349vwwxhxzhr79y";
  };

  configurePhase = ''
    env
    export HOME=$NIX_BUILD_TOP/fake-home
    mkdir -p fake-home
    export STACK_ROOT=$NIX_BUILD_TOP/.stack
    stack config set system-ghc --global true
    stack config set install-ghc --global false
  '';

  installPhase = ''
    mkdir -p $out/bin
    stack --local-bin-path=$out/bin build --copy-bins
    cp -R $src $out/src
  '';
}

