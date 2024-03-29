{
  description = "NixOS deployment for host";

  inputs."nixpkgs".url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = { self, nixpkgs, ... }@attrs:
    let host = "host";
        system = "x86_64-linux";
        modules =
        [ ./host.nix
          ({ lib, ... }:
            { options.inputs = lib.mkOption { type = lib.types.attrs; };
              config.inputs = attrs;
            })
        ];

        pkgs = import nixpkgs { inherit system; };
    in
    { ### Split NixOS configurations for host and containers
      nixosConfigurations =
        let main = nixpkgs.lib.nixosSystem { inherit system modules; };
            containers =
              nixpkgs.lib.attrsets.mapAttrs' (k: v:
                nixpkgs.lib.attrsets.nameValuePair
                  "${host}:${k}"
                  v
              ) main.config.containers;
        in
      { "${host}" = main; } // containers;

      ### NixOS tests for default config
      checks."${system}" =
        let defaultConfig = { ... }: {
              imports = modules ++ [ ./tests/overlays ];
            };
        in
      import ./tests
        { inherit pkgs system defaultConfig; inherit (nixpkgs.lib.nixos) runTest; };

      ### Aliases for toplevel derivation of NixOS configs
      packages."${system}" =
        nixpkgs.lib.attrsets.mapAttrs' (k: v:
          nixpkgs.lib.attrsets.nameValuePair
            "system-${k}"
            v.config.system.build.toplevel
        ) self.nixosConfigurations;
    };
}
