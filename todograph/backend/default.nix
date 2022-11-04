{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc884,
  src,
}:
let depSrc = pkgs.fetchgit {
      url = "https://gitlab.com/b123400/todograph.git";
      rev = "a284017688839957066c6f0ba25d9f8ede1f0a76";
      sha256 = "1xrq94iyxcbbq05m71pr2risaykllj1rj3mj17a0q5bhp4ghxvq4";
    };
    stack = (import ../../stack.nix);
in
    stack {
        name = "todograph";
        inherit pkgs system ghc src depSrc;
    }

