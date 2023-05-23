let secrets = import ./secrets.nix;
    mdblog = import ./mdblog.nix;
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
