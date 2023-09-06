let secrets = import ../secrets.nix;
    carlife = import ./default.nix;
in {
  systemd.services.carlife = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = secrets.carlife.port;
      RELEASE_TMP="/home/b123400/carlife/";
      RELEASE_COOKIE="my_cookie";
      DATABASE_URL=secrets.carlife.databaseURL;
      SECRET_KEY_BASE=secrets.carlife.secretKeyBase;
      HOST="carlife.b123400.net";
      SENDGRID_API_KEY=secrets.carlife.sendgridAPIKey;
    };
    serviceConfig = {
      Type = "simple";
      # WorkingDirectory = /var/www/my-diary.is-he.re;
      ExecStart = ''
        ${carlife}/bin/carlife start
      '';
      ExecStop = ''
        ${carlife}/bin/carlife stop
      '';
      User = "carlife";
    };
  };
  users.extraUsers.carlife = {
    group = "carlife";
    description = "carlife privilege separation user";
    createHome = false;
    isSystemUser = true;
  };
  users.extraGroups.carlife.name = "carlife";
}

