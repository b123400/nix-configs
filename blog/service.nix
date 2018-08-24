let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  nodejs = pkgs.nodejs-8_x;
  mysql = pkgs.mysql57;

  secrets = (import ../secrets.nix).blog;

  blog = (import ./default.nix {}).package;
  # {
  #   inherit stdenv nodejs;
  #   inherit (pkgs) fetchzip utillinux runCommand;
  # };
in {

  systemd.services.ghost = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mysql.service" ];
    environment = {
      NODE_ENV="production";
      url=secrets.url;
      database__client="mysql";
      database__connection__host=secrets.mysqlHost;
      database__connection__user=secrets.mysqlUser;
      database__connection__password=secrets.mysqlPassword;
      database__connection__database=secrets.mysqlDatabase;
      database__connection__charset="utf8mb4";
      server__host="127.0.0.1";
      server__port=secrets.port;
      paths__contentPath=secrets.contentPath;
    };
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "${blog}/lib/node_modules/ghost";
      ExecStartPre = ''
        ${blog}/lib/node_modules/ghost/node_modules/knex-migrator/bin/knex-migrator init
      '';
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
