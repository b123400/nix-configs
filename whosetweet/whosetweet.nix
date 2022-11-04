{ pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc884,
}:

  let src = pkgs.fetchgit {
    url = https://github.com/b123400/whosetweet.git;
    rev = "07c0530fb6296a6e7ae0bb9172cd043234d155e4";
    sha256 = "0iac98v7i3qj2i7j2d814iw33kfds55inkn6jp88qybkfpns2jq4";
  };
    depSrc = src;
    stack = (import ../stack.nix);
  in
  stack {
    name = "whosetweet";
    inherit pkgs system ghc src depSrc;
  }
