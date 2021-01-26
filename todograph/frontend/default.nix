{ src }:

let pkgs = import <nixpkgs> {};
    frontendSrc = "${src}/frontend/";
    buildFrontend = import frontendSrc;
in
   buildFrontend
