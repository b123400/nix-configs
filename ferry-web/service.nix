let pkgs = import <nixpkgs> {};
    ferryWeb = import ./default.nix {
      inherit pkgs src;
    };
    dataDir = "/var/www/ferry-web";
    src = pkgs.fetchgit {
      url = "https://github.com/b123400/ferry-web.git";
      rev = "248be86d7d25931cf10452634ee0f2a6a48e8ca7";
      sha256 = "0jz7wf1f7swfw2pz3aas6rh7plinvm0xmgclk06lqvyzjw8gnr5v";
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
