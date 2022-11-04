{
  pkgs ? import <nixpkgs> { inherit system; },
  system ? builtins.currentSystem,
  nodejs ? pkgs."nodejs-14_x",
}:
let src = pkgs.fetchgit {
      url = "https://gitlab.com/b123400/todograph.git";
      rev = "a284017688839957066c6f0ba25d9f8ede1f0a76";
      sha256 = "1xrq94iyxcbbq05m71pr2risaykllj1rj3mj17a0q5bhp4ghxvq4";
    };
    backend = import ./backend/default.nix { inherit pkgs system src; };
    frontend = import ./frontend/default.nix { inherit src; };
    style = import ./style/default.nix { inherit src pkgs system nodejs; };
in
pkgs.stdenv.mkDerivation {
  name = "todograph";
  version = "v1.0.0";
  inherit src;
  buildInputs = [ frontend backend style pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r static $out
    cp ${frontend}/bundle.js $out/static/js/bundle.js
    cp ${style}/index.css $out/static/css/index.css
    ln -s ${backend}/bin/todograph $out/bin/todograph

    echo -e "$prepareScript" > $out/bin/start.sh
    >>$out/bin/start.sh echo "cp -r \"$out/static\" \"\$1\"" 
    >>$out/bin/start.sh echo "chmod -R 700 \"\$1/static\""
    >>$out/bin/start.sh echo "cd \"\$1\""
    >>$out/bin/start.sh echo "$out/bin/todograph"
    chmod +x $out/bin/start.sh
    wrapProgram $out/bin/start.sh --suffix PATH : "${pkgs.bash}/bin"
  '';

  prepareScript = ''
    #!/usr/bin/env bash
    set -e
    if [ ! -d "$1/config" ]; then
      mkdir -p "$1/config"
    fi
  '';
}
