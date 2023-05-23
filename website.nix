let secrets = import ./secrets.nix;
    mdblog = import ./mdblog.nix;
in {
  systemd.services.website = {
    wantedBy = [ "multi-user.target" ];
    environment = {
    };
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = /var/www/b123400.net;
      ExecStart = ''
        ${mdblog}/bin/mdblog --data /var/www/b123400.net --port ${secrets.website.port} 
      '';
      User = "website";
    };
  };
  users.extraUsers.website = {
    group = "website";
    description = "website privilege separation user";
    createHome = false;
    isSystemUser = true;
  };
  users.extraGroups.website.name = "website";
}
