let pkgs = (import <nixpkgs> {});

in

{ stdenv,
  fetchgit,
  makeWrapper,
  stack,
  ghc
}:

pkgs.haskell.lib.buildStackProject {
  name = "whosetweet";
  buildInputs = [ pkgs.zlib stack makeWrapper ghc ];
  ghc = ghc;
  stack = stack;
  src = fetchgit {
    url = git://github.com/b123400/whosetweet;
    rev = "6d7024471175151a5fec2b50d5bf37334de444f0";
    sha256 = "0aqndkcwl040vwnf8cywn6m5bg53fgwl9a5lnidla18v6gyj24sq";
  };

  configurePhase = ''
    stack --version
    env
    export HOME=$NIX_BUILD_TOP/fake-home
    mkdir -p fake-home
    export STACK_ROOT=$NIX_BUILD_TOP/.stack
    mkdir -p $STACK_ROOT
    stack config set system-ghc true
    #stack config set skip-ghc-check true
    stack config set install-ghc false
    #stack update
    #stack --skip-ghc-check --system-ghc setup
  '';

  installPhase = ''
    mkdir -p $out/bin
    stack --local-bin-path=$out/bin build --copy-bins
    cp -R $src $out/src
  '';

  #extraArgs = ["--skip-ghc-check" "--system-ghc"];

  #stackCmd = "stack --skip-ghc-check --system-ghc";
}

