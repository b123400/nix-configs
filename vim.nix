with import <nixpkgs> {};

vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = ''
      set nocompatible
      set backspace=indent,eol,start
    '';
}
