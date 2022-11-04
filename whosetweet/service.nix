let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  rootDir = "/var/whosetweet";
  secrets = (import ../secrets.nix).whosetweet;

  rawWhosetweet = import ./whosetweet.nix {
    inherit pkgs;
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
    isSystemUser = true;
  };
  users.extraGroups.whosetweet.name = "whosetweet";
}
