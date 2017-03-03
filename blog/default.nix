{ pkgs,
  port ? "2368",
  url,
  host ? "127.0.0.1",
  contentPath,
  mysqlHost ? "127.0.0.1",
  mysqlUser,
  mysqlPassword,
  mysqlDatabase,
  mysqlCharset ? "utf8" }:

let
  nodePackages = import "${pkgs.path}/pkgs/top-level/node-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./node-packages.nix;
  };
  # Fetch sources as zip file, then run them through npm pack.
  # It seems buildNodePackage doesn't like it any other way.
  src = [
    (with rec {
      # fetchzip2 = import ./fetchzip2.nix { inherit pkgs; };
      zipfile = (pkgs.fetchzip {
        url = "https://github.com/TryGhost/Ghost/releases/download/0.11.7/Ghost-0.11.7.zip";
        sha1 = "dys1g4kv12qrfr2g8cl75sy4x4ychgcz";
        stripRoot = false;
      });
    }; pkgs.runCommand "ghost-0.11.7.tgz" { buildInputs = [ pkgs.nodejs ]; } ''
         mv `HOME=$PWD npm pack ${zipfile}` $out
       '')
  ];
in
nodePackages.buildNodePackage {
  name = "ghost-0.11.7";
  inherit src;
  buildInputs = [ ];
  patchPhase = ''
    pwd
    ls -lah
    substituteInPlace package.json --replace 'npm install semver && '

    # Somehow Knex wants mysql to be inside package.json
    substituteInPlace package.json --replace '"mysql": "2.1.1",'
    substituteInPlace package.json --replace '"pg": "6.1.2"'
    substituteInPlace package.json --replace '"xml": "1.0.1"' '"xml": "1.0.1","mysql": "2.1.1","pg": "6.1.2"'

    echo $ghostConfig > config.js
  '';

  ghostConfig = ''
    var path = require('path'),
      config;

    config = {
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


  deps = [
    nodePackages.by-spec."amperize"."0.3.4"
    nodePackages.by-spec."archiver"."1.3.0"
    nodePackages.by-spec."bcryptjs"."2.4.3"
    nodePackages.by-spec."bluebird"."3.4.7"
    nodePackages.by-spec."body-parser"."1.16.0"
    nodePackages.by-spec."bookshelf"."0.10.2"
    nodePackages.by-spec."chalk"."1.1.3"
    nodePackages.by-spec."cheerio"."0.22.0"
    nodePackages.by-spec."compression"."1.6.2"
    nodePackages.by-spec."connect-slashes"."1.3.1"
    nodePackages.by-spec."cookie-session"."1.2.0"
    nodePackages.by-spec."cors"."2.8.1"
    nodePackages.by-spec."csv-parser"."1.11.0"
    nodePackages.by-spec."downsize"."0.0.8"
    nodePackages.by-spec."express"."4.14.1"
    nodePackages.by-spec."express-hbs"."1.0.4"
    nodePackages.by-spec."extract-zip-fork"."1.5.1"
    nodePackages.by-spec."fs-extra"."2.0.0"
    nodePackages.by-spec."ghost-gql"."0.0.6"
    nodePackages.by-spec."glob"."5.0.15"
    nodePackages.by-spec."gscan"."0.2.0"
    nodePackages.by-spec."html-to-text"."3.1.0"
    nodePackages.by-spec."image-size"."0.5.1"
    nodePackages.by-spec."intl"."1.2.5"
    nodePackages.by-spec."intl-messageformat"."1.3.0"
    nodePackages.by-spec."jsonpath"."0.2.9"
    nodePackages.by-spec."knex"."0.12.5"
    nodePackages.by-spec."lodash"."4.17.4"
    nodePackages.by-spec."moment"."2.17.1"
    nodePackages.by-spec."moment-timezone"."0.5.9"
    nodePackages.by-spec."morgan"."1.7.0"
    nodePackages.by-spec."multer"."1.3.0"
    nodePackages.by-spec."netjet"."1.1.3"
    nodePackages.by-spec."nodemailer"."0.7.1"
    nodePackages.by-spec."oauth2orize"."1.7.0"
    nodePackages.by-spec."passport"."0.3.2"
    nodePackages.by-spec."passport-http-bearer"."1.0.1"
    nodePackages.by-spec."passport-oauth2-client-password"."0.1.2"
    nodePackages.by-spec."path-match"."1.2.4"
    nodePackages.by-spec."rss"."1.2.2"
    nodePackages.by-spec."sanitize-html"."1.14.1"
    nodePackages.by-spec."semver"."5.3.0"
    nodePackages.by-spec."showdown-ghost"."0.3.6"
    nodePackages.by-spec."sqlite3"."3.1.8"
    nodePackages.by-spec."superagent"."3.4.1"
    nodePackages.by-spec."unidecode"."0.1.8"
    nodePackages.by-spec."uuid"."3.0.0"
    nodePackages.by-spec."validator"."6.2.1"
    nodePackages.by-spec."xml"."1.0.1"
    nodePackages.by-spec."mysql"."2.1.1"
    nodePackages.by-spec."pg"."6.1.2"
  ];
  peerDependencies = [];
}
