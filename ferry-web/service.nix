let pkgs = import <nixpkgs> {};
    ferryWeb = import ./default.nix {
      inherit pkgs src;
    };
    dataDir = "/var/www/ferry-web";
    src = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "6ef8b811f47defd9ed53ec80a68934c99ee1f34b";
      sha256 = "1xxgnc7rb8mgilja2p07gcwxxlxw5h8wnknvc5fm0k3ilijj4zk3";
    };
    secrets = import ../secrets.nix;
in {
  systemd.services.ferryweb = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = secrets.ferry.port;
      DATA_DIR = dataDir;
    };
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = src;
      ExecStart = ''
        ${ferryWeb}/bin/ferry-web-exe 
      '';
      User = "ferryweb";
    };
  };
  users.extraUsers.ferryweb = {
    group = "ferryweb";
    description = "ferryweb privilege separation user";
    createHome = false;
  };
  users.extraGroups.ferryweb.name = "ferryweb";
}
