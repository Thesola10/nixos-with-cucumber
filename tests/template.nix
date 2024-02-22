{ pkgs, defaultConfig
, featurePath ? ./features  # Path to Behave features directory
, featureName               # Name of feature file to run
, extraNodes ? {}           # Additional machine nodes in test env
, ... }@opts:

{ name = featureName;
  nodes = { machine = defaultConfig; } // extraNodes;
  hostPkgs = pkgs;

  extraPythonPackages = p: with p; [ behave ];

  skipTypeCheck = true;

  testScript = ''
    from behave.configuration import Configuration
    from behave.__main__ import run_behave

    conf = Configuration("${featurePath}/${featureName}", userdata = driver.test_symbols())
    run_behave(conf)
  '';
} // (pkgs.lib.filterAttrs (n: v: n != "pkgs" && n != "defaultConfig" && n != "featurePath" && n != "featureName") opts)

