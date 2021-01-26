{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
  src,
}:
let 
    depSrc = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "248be86d7d25931cf10452634ee0f2a6a48e8ca7";
      sha256 = "0jz7wf1f7swfw2pz3aas6rh7plinvm0xmgclk06lqvyzjw8gnr5v";
    };
    stack = (import ../stack.nix);
in
    stack {
        name = "ferry-web";
        inherit pkgs system ghc src depSrc;
    }
