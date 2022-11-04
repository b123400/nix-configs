let pkgs = import <nixpkgs> {};
    ferryWeb = import ./default.nix {
      inherit pkgs src;
    };
    dataDir = "/var/www/ferry-web";
    src = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "ef6e6528f21d1a336f7b322a837cd4310d5cc495";
      sha256 = "10vwd72a2bag17x5ri5rr998mb47hr9lnxqn7z8i33axj7b3jisk";
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
    isSystemUser = true;
  };
  users.extraGroups.ferryweb.name = "ferryweb";
}
