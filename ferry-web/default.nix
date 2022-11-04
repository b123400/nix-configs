{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc884,
  src,
}:
let 
    depSrc = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "ef6e6528f21d1a336f7b322a837cd4310d5cc495";
      sha256 = "10vwd72a2bag17x5ri5rr998mb47hr9lnxqn7z8i33axj7b3jisk";
    };
    stack = (import ../stack.nix);
in
    stack {
        name = "ferry-web";
        inherit pkgs system ghc src depSrc;
    }
