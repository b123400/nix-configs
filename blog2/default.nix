{ stdenv
, nodejs
, fetchzip
, utillinux
, runCommand
, ... } @ args:

let
  pkgs = import <nixpkgs> {};
  nodePackages = import "${pkgs.path}/pkgs/top-level/node-packages.nix" {
    inherit stdenv nodejs pkgs;
    neededNatives = stdenv.lib.optional stdenv.isLinux utillinux;
    self = nodePackages;
    generated = ./node-packages.nix;
  };
  # Fetch sources as zip file, then run them through npm pack.
  # It seems buildNodePackage doesn't like it any other way.
  src = [
    (with rec {
      zipfile = (fetchzip {
        url = "https://github.com/TryGhost/Ghost/releases/download/1.4.0/Ghost-1.4.0.zip";
        sha1 = "p1yd3j1501kyx4ylwfkmhq6b5fkhac4s";
        stripRoot = false;
      });
    }; runCommand "Ghost-1.4.0.tgz" { buildInputs = [ nodejs ]; } ''
         mv `HOME=$PWD npm pack ${zipfile}` $out
       '')
  ];
in
nodePackages.buildNodePackage ({
  name = "ghost-1.4.0";
  inherit src;

  patchPhase = ''
    # Somehow Knex wants mysql and pg to be inside package.json
    # remove them from optional dependencies, move them to dependencies
    substituteInPlace package.json --replace '"sqlite3": "3.1.8"'
    substituteInPlace package.json --replace '"xml": "1.0.1"' '"xml": "1.0.1","sqlite3": "3.1.8"'
  '';

  deps = [
    nodePackages.by-spec."amperize"."0.3.4"
    nodePackages.by-spec."archiver"."1.3.0"
    nodePackages.by-spec."bcryptjs"."2.4.3"
    nodePackages.by-spec."bluebird"."3.5.0"
    nodePackages.by-spec."body-parser"."1.17.2"
    nodePackages.by-spec."bookshelf"."0.10.3"
    nodePackages.by-spec."brute-knex"."git://github.com/cobbspur/brute-knex.git#37439f56965b17d29bb4ff9b3f3222b2f4bd6ce3"
    nodePackages.by-spec."bson-objectid"."1.1.5"
    nodePackages.by-spec."chalk"."1.1.3"
    nodePackages.by-spec."cheerio"."0.22.0"
    nodePackages.by-spec."compression"."1.6.2"
    nodePackages.by-spec."connect-slashes"."1.3.1"
    nodePackages.by-spec."cookie-session"."1.2.0"
    nodePackages.by-spec."cors"."2.8.3"
    nodePackages.by-spec."csv-parser"."1.11.0"
    nodePackages.by-spec."debug"."2.6.8"
    nodePackages.by-spec."downsize"."0.0.8"
    nodePackages.by-spec."express"."4.15.3"
    nodePackages.by-spec."express-brute"."1.0.1"
    nodePackages.by-spec."express-hbs"."1.0.4"
    nodePackages.by-spec."extract-zip-fork"."1.5.1"
    nodePackages.by-spec."fs-extra"."3.0.1"
    nodePackages.by-spec."ghost-gql"."0.0.6"
    nodePackages.by-spec."ghost-ignition"."2.8.12"
    nodePackages.by-spec."ghost-storage-base"."0.0.1"
    nodePackages.by-spec."glob"."5.0.15"
    nodePackages.by-spec."gscan"."1.1.5"
    nodePackages.by-spec."html-to-text"."3.3.0"
    nodePackages.by-spec."icojs"."0.7.2"
    nodePackages.by-spec."image-size"."0.5.5"
    nodePackages.by-spec."intl"."1.2.5"
    nodePackages.by-spec."intl-messageformat"."1.3.0"
    nodePackages.by-spec."jsdom"."9.12.0"
    nodePackages.by-spec."jsonpath"."0.2.11"
    nodePackages.by-spec."knex"."0.12.9"
    nodePackages.by-spec."knex-migrator"."2.1.4"
    nodePackages.by-spec."lodash"."4.17.4"
    nodePackages.by-spec."markdown-it"."8.3.1"
    nodePackages.by-spec."markdown-it-footnote"."3.0.1"
    nodePackages.by-spec."markdown-it-lazy-headers"."0.1.3"
    nodePackages.by-spec."markdown-it-mark"."2.0.0"
    nodePackages.by-spec."markdown-it-named-headers"."0.0.4"
    nodePackages.by-spec."mobiledoc-dom-renderer"."0.6.5"
    nodePackages.by-spec."moment"."2.18.1"
    nodePackages.by-spec."moment-timezone"."0.5.13"
    nodePackages.by-spec."multer"."1.3.0"
    nodePackages.by-spec."mysql"."2.13.0"
    nodePackages.by-spec."nconf"."0.8.4"
    nodePackages.by-spec."netjet"."1.1.3"
    nodePackages.by-spec."nodemailer"."0.7.1"
    nodePackages.by-spec."oauth2orize"."1.8.0"
    nodePackages.by-spec."passport"."0.3.2"
    nodePackages.by-spec."passport-ghost"."2.3.1"
    nodePackages.by-spec."passport-http-bearer"."1.0.1"
    nodePackages.by-spec."passport-oauth2-client-password"."0.1.2"
    nodePackages.by-spec."path-match"."1.2.4"
    nodePackages.by-spec."rss"."1.2.2"
    nodePackages.by-spec."sanitize-html"."1.14.1"
    nodePackages.by-spec."semver"."5.3.0"
    nodePackages.by-spec."simple-dom"."0.3.2"
    nodePackages.by-spec."simple-html-tokenizer"."0.4.1"
    nodePackages.by-spec."superagent"."3.5.2"
    nodePackages.by-spec."unidecode"."0.1.8"
    nodePackages.by-spec."uuid"."3.1.0"
    nodePackages.by-spec."validator"."6.3.0"
    nodePackages.by-spec."xml"."1.0.1"
    nodePackages.by-spec."sqlite3"."3.1.8"
  ];
  peerDependencies = [];
} // (stdenv.lib.filterAttrs (n: v: stdenv.lib.all (k: n != k) ["stdenv" "nodejs" "fetchzip" "utillinux" "runCommand"]) args))
