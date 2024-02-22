{ pkgs, lib, ... }:
{ name = "test-basic";
  machine =
    { lib, ... }:
    { # We base our test machine on our host config (otherwise what's the point?)
      imports =
      [ ../host.nix
      ];
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")
  '';
}
