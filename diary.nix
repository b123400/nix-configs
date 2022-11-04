let pkgs = import <nixpkgs> {};
    secrets = import ./secrets.nix;
    mdblog = pkgs.rustPlatform.buildRustPackage rec {
      pname = "mdblog";
      version = "0.1.0";

      src = pkgs.fetchgit {
        url = "https://git.sr.ht/~not/mdblog";
        rev = "1f9745afe97b8e294ee637e7ec194dd33f7d556f";
        sha256 = "sha256-TUCcluHhCwz6NDotb26GkuSo+mTNtqw7dPgpe1jg6Ds=";
      };

      cargoSha256 = "0c6rsrd6bk5gwr4jkb3garplkd9rqhnlrql7ir0hgm74w5224qb4";
    };

in {
  systemd.services.diary = {
    wantedBy = [ "multi-user.target" ];
    environment = {
    };
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = /var/www/my-diary.is-he.re;
      ExecStart = ''
        ${mdblog}/bin/mdblog --data /var/www/my-diary.is-he.re/data --port ${secrets.diary.port} 
      '';
      User = "diary";
    };
  };
  users.extraUsers.diary = {
    group = "diary";
    description = "diary privilege separation user";
    createHome = false;
    isSystemUser = true;
  };
  users.extraGroups.diary.name = "diary";
}
