{ pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
}:

  let src = pkgs.fetchgit {
    url = git://github.com/b123400/whosetweet;
    rev = "df34c32fb94335e879169f936db26c137fb8dc34";
    sha256 = "17xak98mf1y2dkc9bjwlcc794c0mrb7q54hy23101p40x3zr965w";
  };
    depSrc = src;
    stack = (import ../stack.nix);
  in
  stack {
    name = "whosetweet";
    inherit pkgs system ghc src depSrc;
  }
