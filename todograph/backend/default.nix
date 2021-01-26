{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
  src,
}:
let depSrc = pkgs.fetchgit {
      url = "https://gitlab.com/b123400/todograph.git";
      rev = "1980eec4797affe8be28170a4a9d319025b0f6a0"; 
      sha256 = "14wf730g0jwh64m9q6lg2fqa1gv1y7wbs15va0f8pbqk9i8gkc3a";
    };
    stack = (import ../../stack.nix);
in
    stack {
        name = "todograph";
        inherit pkgs system ghc src depSrc;
    }

