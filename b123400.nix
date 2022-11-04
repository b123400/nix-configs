{
  users.extraUsers.b123400 =
  { isNormalUser = true;
    home = "/home/b123400";
    description = "b";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjLtOvRONC7UzrAs4LVo9UC9TqXIjaIjPVnt3yGzSzOz+9L/AGfuITfUCfWR4vCrnXYgsFzYFOLfe1tQAos0cA0x0V8vSklLOJltlfWz0jio6Sin+nMiYgefCIKFAkcsbVcol1/+dW+nCnIuidDCh0faRIcnxoAsqoUPhax2S2TiBKAgBvGnoQ3vEZm3/J3WtSMpo2x5l4F4rvf/7oBpNwbrWSx5u0EkKKk4aE2rH8jnuJoKUFmAF6Ky7LGuvJ4zaKftrGVd1hgPs7282qGYSFzuTzJe6/egakK1LvL5o1hFWi/D0GV1XV+999KiME3HN+s1xNOg2XAU4lYqCPhFej b123400@gmail.com''
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDyp1gbTOa4tPcGzjsVQsT8BRQaz3d7ASQ3caQwxKAkBax5JVx9RpnJgM3Ih4sqdoNFduVEBpFl/V/GbfDWTquxr+DhEbT+pyRK9Lhsns+YkDDPJWYmCHBnZMeeBHPFmsNrUiytWK88YK24lscIs1klW7Cetzr/bPG0dLU+4bEaXYbnrJYb4doYVlu7RWy4TnDcno2qgidHZXHQLrip39vfoVC+danjjEG6EPUl/8jLBiUteGFqN0Pwq20T6j0M7d6ARSuWYzrs5gEZeIj3w9YiTygH80SOkiqlP0olyZxE31AIuV37Zyb4YE0EnVUCGP+GnpqXMAeSi2VnPgEKcV4d
''  # Powermac G5
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz/OnfTPafPXKutI1FlnNHrnV+VNK+loX92SpIAzm4o02408LiYOf2PtAO5IZF0MXw6uAzzmoDF2XZwdAjqnXFf2VTmQ1mBExOmUK6V4IhD9a7yExRSa/I7THWhWAdE3Q5aReEBIw8CJFMTLGpkYUtR6+kES+3c1/Roc5IxMBBZFnqkUeZ0gqBGC05OxccInsDWVdUa5xCJAuAsXBsPegJ6PfBUJFWrJlBpZUPVySXT6BD1GdrhG135Gy8a1PKcsoRXuZN2uoyemPgaF2vA4nEGq6yVsd8O12lm38fyUzGAahQfMosaLqUMBseb0vjG5e4kpOCoYGdYDcFFd5B4T/ZbxY4MCSnjWtyNXh545JFEXt71SzzxdYmz03l3lRGA4XgfQOCw5+8egseGa9JCAR18zrNJBT1Bhp2FXmzMkyjt5Vb3np9lGdEIbr3opI+x8Goa0DLbuvs1teC7utd2NPDuNOzj2c4LZNlduTvln0BhfprLQbNMCElnx5dBTzNMms= b123400@b123400s-Mac-mini.local
''  # Mac mini M1
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwESx+0OKdm6Adkd006bRqjuqAOmAxwP5gPdoP+4XoTa6fmzOgWpAPOkmL+Hjw8Vvpq97XUkPubJKw7uKdGAv0XP3L2qm+7orv7hg+esptpv/sCobT0eWpz/+C0K/Axt6anl4EPtNbzcVGJeAj46x2pksP3LmKoa1zXrHYVzuTeQaPOiMlD/lRykqpE54bWA50BntWPS8xXZy7rDJD8e5Xdhkn6RikNihUZ5TrjsOJJQ3ZgOFWln7BbINWLy4nQxk/u57Hg9no++a9T+WJYAAV5X1uU9Qumq5+bhFSzVTI7tbrsqsriPZxz0W8RVPuVQxKLWBJCpcl+D6/Gp5kGiDR b123400@oriharasan.local
''  # Orihara Air
    ];
  };
}

