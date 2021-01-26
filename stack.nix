# I was trying to build a Stack project...
#
# The previous way I used is with pkgs.haskell.lib.buildStackProject,
# which is ok except on the latest nixpkgs, it comes with Stack 2,
# and that does not work on nixos[1].
#
# Well, a solution seems to be just use Stack 1.9.3, that is good
# except Stack 1.9.3 is not supported since LTS-15.[2]
#
# So... what's the nix way of doing it?
# There are cabal2nix, stackage2nix, stack2nix, which none of
# them seems to work for me. The community seems to be moving to
# haskell.nix, which seems nice except it's building ghc from ground up
# on my machine. Tried to setup cachix but no luck. And tbh, setting the
# tools itself takes a long time already.
#
# After all what do I want? I just want to build a Stack project.
# A simple `stack build` should do. Some possible issues with this
# approach:
# 1. It requires internet connection, so it has to be ran with
#    `--option sandbox false`, but the built-in `buildStackProject`
#    already requires that[3], so I guess nothing is getting worse.
# 2. Files are not managed by Nix so integrity might be a problem?
#    But stack project comes with `stack.yaml.lock`, should be ok.
# 3. Running `stack build` directly means no cache at all, every build
#    is going to take a long time. Well that's why this file exists.
#
# To shorten the build time, I need cache. My first thought was,
# "Why dont just build once, copy the .stack-work folder and reuse it."
# This approach is almost working, except `.stack-work` is not really portable.
# The packages managed by ghc-pkg are exported with absolute paths.
# Ghc-pkg supports relative paths, but Stack explicitly choose absolute path[4]
# to workaround problems on Windows, and there is no way to configure it.
# So my workaround is to patch the files in the `.stack-work` folder.
# Replace all the absolute path with ${pkgroot} then regenerate the cache db.
#
# To use this function, 2 sources are needed, they can be the same source.
# One as dependency and one is the actual source. The ideal use case is like:
#
# First time:
#     { depSrc = src, src = <source version 1>; }
# Build succeed and depSrc's `.stack-work` is somewhere in Nix store.
#
# Second time:
#     { depSrc = <source version 1>; src = <source version 2>; }
# Then it would build the source with the dependency from the old version.
#
# Downsides:
# 1. If I run nix-collect-garbage, the cache is gone. I have to
#    manually maintain it, not exactly a big problem.
# 2. The nix files depends on how do I operate,
#    e.g. if I just deleted the cache, I better set the `depSrc` to `src`
#    because cache would be rebuilt anyway. The newer the better.
#
# Otherwise it's alright, not perfect but at least it works.
#
# [1]: https://github.com/commercialhaskell/stack/issues/5000
# [2]: https://github.com/commercialhaskell/stack/issues/5204
# [3]: https://nixos.org/nixpkgs/manual/#how-to-build-a-haskell-project-using-stack
# [4]: https://github.com/commercialhaskell/stack/commit/82751b217a1ab4a4cee6cc92ca10e953cef75ce2

{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  ghc ? pkgs.haskell.compiler.ghc883,
  depSrc,
  src,
  name,
  keepDeps ? true,
}:
let deps = pkgs.stdenv.mkDerivation {
      name = "${name}-deps";
      version = "v1.0.0";
      src = depSrc;
      buildInputs = [ pkgs.stack pkgs.zlib ghc pkgs.gnugrep ];
      LANG = "en_US.UTF-8";

      configurePhase = ''
        export HOME=$NIX_BUILD_TOP/fake-home
        export STACK_ROOT=$NIX_BUILD_TOP/.stack
        mkdir -p fake-home
        mkdir -p $STACK_ROOT
        stack config set system-ghc true
        stack config set install-ghc false
        echo 'allow-different-user: true' >>"$STACK_ROOT/config.yaml"
      '';

      buildPhase = ''
        stack build --no-nix -j4 --only-dependencies
      '';

      installPhase = ''
        for filepath in $STACK_ROOT/snapshots/*/*/*/pkgdb/*.conf; do
          PKGROOT=$(dirname $(dirname "$filepath"))
          echo "Replacing $filepath"
          substituteInPlace "$filepath" --replace " $PKGROOT/" ' ''${pkgroot}/'
        done

        PKGDB=$(stack --no-nix exec -- ghc-pkg list | grep "\\.stack/" | grep "/pkgdb")
        echo "Recaching $PKGDB"
        stack --no-nix exec -- ghc-pkg --user --no-user-package-db --package-db "$PKGDB" recache
        echo "Recached"

        mkdir -p $out
        mv $STACK_ROOT $out/.stack
        mv .stack-work $out/.stack-work
      '';
    };
    keepDepsCommand = if !keepDeps then "" else "ln -s ${deps} $out/deps";
in
pkgs.stdenv.mkDerivation {
  name = name;
  version = "v1.0.0";
  src = src;
  buildInputs = [ pkgs.stack pkgs.zlib ghc ];
  LANG = "en_US.UTF-8";

  __noChroot = true;
  configurePhase = ''
    env
    export HOME=$NIX_BUILD_TOP/fake-home
    export STACK_ROOT=$NIX_BUILD_TOP/.stack

    cp -R ${deps}/.stack $STACK_ROOT
    cp -R ${deps}/.stack-work .stack-work
    mkdir -p fake-home

    chown -R "$(whoami)" $STACK_ROOT/
    chown -R "$(whoami)" .stack-work/
    chmod -R 777 $STACK_ROOT/
    chmod -R 777 .stack-work/

    stack config set system-ghc true
    stack config set install-ghc false
  '';

  buildPhase = ''
    stack build --no-nix -j4
  '';

  installPhase = ''
    mkdir -p $out/bin
    stack --no-nix --local-bin-path=$out/bin build --copy-bins
    ${keepDepsCommand}
  '';
}

