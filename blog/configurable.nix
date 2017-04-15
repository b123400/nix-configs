{ stdenv
, nodejs
, fetchzip
, utillinux
, runCommand

,  port ? "2368"
,  url
,  host ? "127.0.0.1"
,  contentPath
,  mysqlHost ? "127.0.0.1"
,  mysqlUser
,  mysqlPassword
,  mysqlDatabase
,  mysqlCharset ? "utf8" }:

let
  ghost = import ./default.nix;
in
  ghost {
    inherit stdenv nodejs fetchzip utillinux runCommand;

    postConfigure = ''
      echo $ghostConfig > config.js
    '';

    ghostConfig = ''
      var config = {
        production: {
          url: '${url}',
          mail: {},
          database: {
            client: 'mysql',
            connection: {
              host     : '${mysqlHost}',
              user     : '${mysqlUser}',
              password : '${mysqlPassword}',
              database : '${mysqlDatabase}',
              charset  : '${mysqlCharset}'
            },
            debug: false
          },
          server: {
            host: '${host}',
            port: '${port}'
          },
          paths: {
            contentPath: '${contentPath}',
          },
        },
      };
      module.exports = config;
    '';
  }
