# This file has been generated by node2nix 1.6.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {
    "amdefine-1.0.1" = {
      name = "amdefine";
      packageName = "amdefine";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/amdefine/-/amdefine-1.0.1.tgz";
        sha1 = "4a5282ac164729e93619bcfd3ad151f817ce91f5";
      };
    };
    "balanced-match-1.0.0" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    };
    "brace-expansion-1.1.11" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "1.1.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha512 = "iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==";
      };
    };
    "concat-map-0.0.1" = {
      name = "concat-map";
      packageName = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    };
    "css-parse-1.7.0" = {
      name = "css-parse";
      packageName = "css-parse";
      version = "1.7.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/css-parse/-/css-parse-1.7.0.tgz";
        sha1 = "321f6cf73782a6ff751111390fc05e2c657d8c9b";
      };
    };
    "debug-4.0.1" = {
      name = "debug";
      packageName = "debug";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-4.0.1.tgz";
        sha512 = "K23FHJ/Mt404FSlp6gSZCevIbTMLX0j3fmHhUEhQ3Wq0FMODW3+cUSoLdy1Gx4polAf4t/lphhmHH35BB8cLYw==";
      };
    };
    "fs.realpath-1.0.0" = {
      name = "fs.realpath";
      packageName = "fs.realpath";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    };
    "glob-7.0.6" = {
      name = "glob";
      packageName = "glob";
      version = "7.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-7.0.6.tgz";
        sha1 = "211bafaf49e525b8cd93260d14ab136152b3f57a";
      };
    };
    "inflight-1.0.6" = {
      name = "inflight";
      packageName = "inflight";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    };
    "inherits-2.0.3" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    };
    "minimatch-3.0.4" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "3.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz";
        sha512 = "yJHVQEhyqPLUTgt9B83PXu6W3rx4MvvHvSUvToogpwoGDOUQ+yDrR0HRot+yOCdCO7u4hX3pWft6kWBBcqh0UA==";
      };
    };
    "minimist-0.0.8" = {
      name = "minimist";
      packageName = "minimist";
      version = "0.0.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    };
    "mkdirp-0.5.1" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.5.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
    };
    "ms-2.1.1" = {
      name = "ms";
      packageName = "ms";
      version = "2.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.1.1.tgz";
        sha512 = "tgp+dl5cGk28utYktBsrFqA7HKgrhgPsg6Z/EfhWI4gl1Hwq8B/GmY/0oXZ6nF8hDVesS/FpnYaD/kOWhYQvyg==";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    };
    "path-is-absolute-1.0.1" = {
      name = "path-is-absolute";
      packageName = "path-is-absolute";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    };
    "sax-0.5.8" = {
      name = "sax";
      packageName = "sax";
      version = "0.5.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
        sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
      };
    };
    "source-map-0.1.43" = {
      name = "source-map";
      packageName = "source-map";
      version = "0.1.43";
      src = fetchurl {
        url = "https://registry.npmjs.org/source-map/-/source-map-0.1.43.tgz";
        sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
      };
    };
    "stylus-0.54.5" = {
      name = "stylus";
      packageName = "stylus";
      version = "0.54.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/stylus/-/stylus-0.54.5.tgz";
        sha1 = "42b9560931ca7090ce8515a798ba9e6aa3d6dc79";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    };
  };
  args = {
    name = "todograph";
    packageName = "todograph";
    version = "1.0.0";
    src = ./.;
    dependencies = [
      sources."amdefine-1.0.1"
      sources."balanced-match-1.0.0"
      sources."brace-expansion-1.1.11"
      sources."concat-map-0.0.1"
      sources."css-parse-1.7.0"
      sources."debug-4.0.1"
      sources."fs.realpath-1.0.0"
      sources."glob-7.0.6"
      sources."inflight-1.0.6"
      sources."inherits-2.0.3"
      sources."minimatch-3.0.4"
      sources."minimist-0.0.8"
      sources."mkdirp-0.5.1"
      sources."ms-2.1.1"
      sources."once-1.4.0"
      sources."path-is-absolute-1.0.1"
      sources."sax-0.5.8"
      sources."source-map-0.1.43"
      sources."stylus-0.54.5"
      sources."wrappy-1.0.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      homepage = "https://gitlab.com/b123400/todograph#README";
    };
    production = false;
    bypassCache = true;
  };
in
{
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
}