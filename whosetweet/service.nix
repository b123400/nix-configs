let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  fetchgit = pkgs.fetchgit;
  ghc = pkgs.haskell.compiler.ghc865;
  makeWrapper = pkgs.makeWrapper;
  
  #stack = pkgs.stack;

  nixpkgs-19-03-tarball = builtins.fetchTarball {
    # Channel nixos-19.03 as of 2019/08/12.
    url = "https://github.com/NixOS/nixpkgs/archive/56d94c8c69f8cac518027d191e2f8de678b56088.tar.gz";
    sha256 = "1c812ssgmnmh97sarmp8jcykk0g57m8rsbfjg9ql9996ig6crsmi";
  };

  nixpkgs-19-03 = import nixpkgs-19-03-tarball {};

  stack = nixpkgs-19-03.stack;

  rootDir = "/var/whosetweet";
  secrets = (import ../secrets.nix).whosetweet;

  rawWhosetweet = import ./whosetweet.nix {
    inherit stdenv fetchgit makeWrapper stack ghc;
  };

  whosetweet = stdenv.mkDerivation {
    name = "whosetweet";

    buildInputs = [
      pkgs.makeWrapper
    ];
    bash = pkgs.bash;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup;
      mkdir -p $out
      echo -e "$startScript" > $out/start.sh
      chmod +x $out/start.sh
      wrapProgram $out/start.sh --suffix PATH : "$bash/bin"
    '';

    startScript = ''
      #!/usr/bin/env bash
      if [ ! -d "${rootDir}/src" ]; then
        mkdir -p ${rootDir}
        cp -r ${rawWhosetweet}/src ${rootDir}/src
        chmod -R 700 ${rootDir}/src
      fi
      cd ${rootDir}/src
      ${rawWhosetweet}/bin/whosetweet
    '';
  };

in {

  systemd.services.whosetweet = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = secrets.port;
      TWITTER_CLIENT_ID = secrets.twitterClientKey;
      TWITTER_CLIENT_SECRET = secrets.twitterClientSecret;
      APPROOT = secrets.url;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${whosetweet}/start.sh
      '';
      User = "whosetweet";
    };
    path = [];
  };

  users.extraUsers.whosetweet = {
    group = "whosetweet";
    description = "Whosetweet privilege separation user";
    home = rootDir;
    createHome = true;
  };
  users.extraGroups.whosetweet.name = "whosetweet";
}
