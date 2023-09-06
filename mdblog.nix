let pkgs = import <nixpkgs> {};
in pkgs.rustPlatform.buildRustPackage rec {
      pname = "mdblog";
      version = "0.1.0";

      src = pkgs.fetchgit {
        url = "https://git.sr.ht/~not/mdblog";
        rev = "81e6f7e3f9976dff128bf94ca9356e8e46a8469b";
        sha256 = "sha256-BKziTBfrFyVErDMSnLU8ueLDPkbyZWW1WJvDjR0yXAg=";
      };

      cargoSha256 = "sha256-TOADPVf6G9E2bQEJEsVifF0JdwDVCmeNzDvC+tZT9lY=";
    }
