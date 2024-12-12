with import <nixpkgs> { };

let
  # beam.interpreters.erlang_23 is available if you need a particular version
  packages = beam.packagesWith beam.interpreters.erlang;

  pname = "carlife";
  version = "0.0.1";

  src = fetchGit {
    url = "https://git.sr.ht/~not/carlife";
    rev = "9ff62822e91bf27dbf20cf6ac884417e2b751350";
  };

  # if using mix2nix you can use the mixNixDeps attribute
  mixFodDeps = packages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    # nix will complain and tell you the right value to replace this with
    #sha256 = lib.fakeHash
    sha256 = "sha256-GKlo5m05cf9Wg8J3MiO9fxfGQjVwxcIc8WrkgNFdKuM=";
    mixEnv = "prod"; # default is "prod", when empty includes all dependencies, such as "dev", "test".
  };

in packages.mixRelease {
  inherit src pname version mixFodDeps;
  # if you have build time environment variables add them here
  MIX_ENV="prod";
  MIX_ESBUILD_PATH="${esbuild}/bin/esbuild";
  buildInputs = [
  ];
  NODE_PATH="${mixFodDeps}";

  preBuild = ''
    mix assets.prod.deploy
  '';

  postBuild = ''
    ls priv/static/assets
    mix phx.gen.release
  '';
}

