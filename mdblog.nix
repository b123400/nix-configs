let pkgs = import <nixpkgs> {};
in pkgs.rustPlatform.buildRustPackage rec {
      pname = "mdblog";
      version = "0.1.0";

      src = pkgs.fetchgit {
        url = "https://git.sr.ht/~not/mdblog";
        rev = "d0612d2a6c0fd4d736108359a024b50bcc3b3ce4";
        sha256 = "sha256-Y2L3nitIV6EuHWP5KTbe/OccL5eGeRSSlZorKWiVGpM=";
      };

      cargoSha256 = "sha256-TOADPVf6G9E2bQEJEsVifF0JdwDVCmeNzDvC+tZT9lY=";
    }
