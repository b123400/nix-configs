{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
}:
let src = depSrc;
    depSrc = pkgs.fetchgit {
      url = "https://gitlab.com/b123400/todograph.git";
      rev = "d25e861559127ce83b37648a168a725772fc54df";
      sha256 = "19lw4k5c1mrczjm1j82pdd9xqaw5i1128q6c4711d2k5xif3g6kb";
    };
    stack = (import ../../stack.nix);
in
    stack {
        name = "todograph";
        inherit pkgs system ghc src depSrc;
    }

