with (import <nixpkgs> {});

{ stdenv,
  fetchgit,
  makeWrapper,
  stack }:

let
  ghc = haskell.compiler.ghc7102;
in
haskell.lib.buildStackProject {
  name = "whosetweet";
  buildInputs = [ zlib stack makeWrapper ghc ];
  ghc = ghc;
  src = fetchgit {
    url = git://github.com/b123400/whosetweet;
    rev = "76649f2e06210b988abc77d7c329c0b45755c3fa";
    sha256 = "0ypxkba6rqbdn6ajhwcnhjqh46n84dqz0pxilbg6hnldy6k8wdw2";
  };

  configurePhase = ''
    env
    export HOME=$NIX_BUILD_TOP/fake-home
    mkdir -p fake-home
    export STACK_ROOT=$NIX_BUILD_TOP/.stack
    stack config set system-ghc --global true
  '';

  installPhase = ''
    mkdir -p $out/bin
    stack --local-bin-path=$out/bin build --copy-bins
    cp -R $src $out/src
  '';
}

