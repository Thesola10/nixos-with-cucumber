{ pkgs, defaultConfig, ... }:
{ name = "test-basic";
  nodes.machine = defaultConfig;
  hostPkgs = pkgs;

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")
  '';
}
