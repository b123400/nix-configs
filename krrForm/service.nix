let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  makeWrapper = pkgs.makeWrapper;
  nodejs = pkgs.nodejs-10_x;
  secret = (import ../secrets.nix).krrForm;

  krrForm = import /var/www/krr-2019-form/override.nix {};
in {

  systemd.services.krrForm = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = secret.port;
      DB_FILE = "/var/www/krr-2019-form-store/store.db";
      MAX_ENTRY = "30";
    };
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "${krrForm.package}/lib/node_modules/kururu-2019-form";
      ExecStart = ''
        ${pkgs.nodejs-10_x}/bin/node server/index.js
      '';
      User = "krrForm";
    };
    path = [];
  };

  users.extraUsers.krrForm = {
    group = "krrForm";
    description = "krrForm privilege separation user";
    createHome = true;
  };
  users.extraGroups.krrForm.name = "krrForm";
}
