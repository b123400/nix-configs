let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  nodejs = pkgs.nodejs-7_x;
  mysql = pkgs.mysql57;

  secrets = (import ../secrets.nix).blog2;

  blog = import ./default.nix {
    inherit stdenv nodejs;
    inherit (pkgs) fetchzip utillinux runCommand;
  };
in {

  systemd.services.ghost2 = {
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
      database__connection__charset="utf8";
      server__host="127.0.0.1";
      server__port=secrets.port;
      paths__contentPath=secrets.contentPath;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${nodejs}/bin/node ${blog}/lib/node_modules/ghost/index.js
      '';
      ExecStop = ''
      '';
      User = "ghost2";
    };
  };

  users.extraUsers.ghost2 = {
    group = "ghost2";
    description = "ghost privilege separation user";
    createHome = false;
  };
  users.extraGroups.ghost2.name = "ghost2";
}
