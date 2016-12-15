let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  fetchurl = pkgs.fetchurl;
  unzip = pkgs.unzip;
  nodejs = pkgs.nodejs;
  elixir = pkgs.elixir;
  mysql = pkgs.mysql57;
  makeWrapper = pkgs.makeWrapper;

  secrets = (import ../secrets.nix).danmaku;

  danmaku = import ./danmaku.nix {
    inherit stdenv fetchurl unzip nodejs elixir makeWrapper mysql;

    mysqlHost = secrets.mysqlHost;
    mysqlUsername = secrets.mysqlUsername;
    mysqlPassword = secrets.mysqlPassword;
    mysqlDatabase = secrets.mysqlDatabase;
    secretKey = secrets.secretKey;
  };

  dataDir = secrets.dataDir;
in {

  systemd.services.danmaku = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mysql.service" ];
    environment = {
      PORT = secrets.port;
      RELEASE_MUTABLE_DIR = dataDir;
      HOME = dataDir;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${danmaku}/bin/migrate_and_start.sh
      '';
      ExecStop = ''
        ${danmaku}/bin/danmaku_api stop
      '';
      User = "danmaku";
    };
    path = [pkgs.procps pkgs.gawk pkgs.utillinux];
  };

  users.extraUsers.danmaku = {
    group = "danmaku";
    description = "danmaku privilege separation user";
    home = dataDir;
    createHome = true;
  };
  users.extraGroups.danmaku.name = "danmaku";
}

