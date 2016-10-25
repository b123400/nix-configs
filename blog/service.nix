let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  nodejs = pkgs.nodejs-4_x;
  mysql = pkgs.mysql57;

  secrets = (import ../secrets.nix).blog;

  blog = import ./default.nix {
    pkgs = import <nixpkgs> {};
    port = secrets.port;
    url = secrets.url;
    host = "127.0.0.1";
    contentPath = secrets.contentPath;
    mysqlHost = secrets.mysqlHost;
    mysqlUser = secrets.mysqlUser;
    mysqlPassword = secrets.mysqlPassword;
    mysqlDatabase = secrets.mysqlDatabase;
    mysqlCharset = "utf8";
  };
in {

  systemd.services.ghost = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mysql.service" ];
    environment = {
      NODE_ENV="production";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${nodejs}/bin/node ${blog}/lib/node_modules/ghost/index.js
      '';
      ExecStop = ''
      '';
      User = "ghost";
    };
  };

  users.extraUsers.ghost = {
    group = "ghost";
    description = "ghost privilege separation user";
    createHome = false;
  };
  users.extraGroups.ghost.name = "ghost";
}
