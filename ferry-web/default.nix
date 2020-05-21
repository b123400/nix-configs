{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
  src,
}:
let 
    depSrc = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "22fec2667d5682052671555b29a2f4a6ebf01d83";
      sha256 = "1j75s9h2hc4ds6aqq6002hq0x6h08fr2j8f69w7gd4mh1796k1b3";
    };
    stack = (import ../stack.nix);
in
    stack {
        name = "ferry-web";
        inherit pkgs system ghc src depSrc;
    }
