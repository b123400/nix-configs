let pkgs = import <nixpkgs> {};
    todograph = import ./default.nix {
      inherit pkgs;
    };
    dataDir = "/var/www/todograph";
    secrets = import ../secrets.nix;
in {
  systemd.services.todograph = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = secrets.todograph.port;
      STATIC_DIR = "${dataDir}/static";
      NEO4J_USER = secrets.todograph.neo4jUsername;
      NEO4J_PASSWORD = secrets.todograph.neo4jPassword;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${todograph}/bin/start.sh ${dataDir}
      '';
      User = "todograph";
    };
  };
  users.extraUsers.todograph = {
    group = "todograph";
    description = "todograph privilege separation user";
    createHome = false;
  };
  users.extraGroups.todograph.name = "todograph";
}
