{ pkgs ?    import <nixpkgs> {}
, system ?  builtins.currentSystem
, runTest ?
    (import <nixpkgs/nixos/lib/testing> { inherit (pkgs) lib; }).runTest
, defaultConfig ?
    { ... }: { imports = [ ../configuration.nix ./overlays ]; }
, ... }:

#
# Root file for the set of unit tests on this config. Unit tests make use of
# the NixOS unit test framework, and individual tests can be registered in the
# same format as in Nixpkgs, or as Behave features using the 'behaveTest' call.
# Documentation for the unit test frameowkr is available in the NixOS manual:
#
#   https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests
#

let
  runTest' = a: b: runTest
    (import a ({ inherit defaultConfig system pkgs; } // b));
  behaveTest = featureName: as: runTest
    (import ./template.nix ({ inherit defaultConfig pkgs featureName; }//as));
in
{ "basic" = behaveTest "basic.feature" {};
  "basic2" = runTest' ./test-basic.nix {};
}

# Note: To run an individual unit test automatically (as part of the suite),
# run the following:
#   nix build .#checks.x86_64-linux.(test name)
# or:
#   nix-build ./tests -A (test name)
#
# To debug a test (i.e. run it interactively), the command isn't very different
#   nix run .#checks.x86_64-linux.(test name).driverInteractive
# or:
#   nix-build ./tests -A (test name).driverInteractive
# followed by:
#   ./result/bin/nixos-test-driver --interactive
