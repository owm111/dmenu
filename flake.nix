{
	description = "My fork of dmenu";

	outputs = {self, nixpkgs}: {
		lib = {
			pkgsForEach = nixpkgs: cfg: systems: attrs: let
				sys2attrset = system: {
					name = system;
					value = let
						pkgs = import nixpkgs (cfg // {
							inherit system;
						});
						apply = _: f: f pkgs system;
					in builtins.mapAttrs apply attrs;
				};
			in builtins.listToAttrs (map sys2attrset systems);
		};

		devShells = self.lib.pkgsForEach nixpkgs {} ["x86_64-linux"] {
			default = pkgs: system: pkgs.mkShell {
				buildInputs = [
					pkgs.xorg.libX11
					pkgs.xorg.libXft
					pkgs.xorg.libXinerama
				];
			};
		};
	};
}
