{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { inherit system; };

      mkTypstWrapper =
        {
          fonts ? [ ],
          packages ? { },
          typst ? pkgs.typst,
          tinymist ? null,
          ...
        }:
        let
          packagePath =
            if lib.all (v: v == [ ]) (lib.attrValues packages) then
              pkgs.emptyDirectory
            else
              let
                devPackages = lib.concatMap (lib.getAttr "propagatedBuildInputs") (lib.concatAttrValues packages);
                packages' = lib.mapAttrs (_: lib.unique) (
                  packages // { preview = (packages.preview or [ ]) ++ devPackages; }
                );
              in
              pkgs.runCommand "package-path" { } (
                lib.join "\n" (
                  lib.flatten [
                    (lib.mapAttrsToList (namespace: packs: [
                      (map (package: [
                        "mkdir -p $out/${namespace}/${package.pname}"
                        "ln -s ${package}/lib/typst-packages/${package.pname}/${package.version} $out/${namespace}/${package.pname}"
                      ]) packs)
                    ]) packages')
                  ]
                )
              );

          enviroment = {
            TYPST_IGNORE_SYSTEM_FONTS = "true";
            TYPST_PACKAGE_CACHE_PATH = packagePath;
            TYPST_PACKAGE_PATH = packagePath;
          }
          // (if fonts == [ ] then { } else { TYPST_FONT_PATHS = lib.concatStringsSep ":" fonts; });
          installWrapper = pkg: name: [
            "makeWrapper ${lib.getExe pkg} $out/bin/${name} ${
              lib.concatMapAttrsStringSep " " (
                name: value: "--set ${name} ${lib.escapeShellArg value}"
              ) enviroment
            }"
            "cp --no-preserve=all -r ${pkg}/share/* $out/share"
          ];
          tinymist' =
            if tinymist == true then
              pkgs.tinymist
            else if tinymist == false then
              null
            else
              tinymist;
        in
        pkgs.runCommand "typst-wrapper" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } (
          lib.join "\n" (
            lib.flatten [
              "mkdir -p $out/share"

              (installWrapper typst "typst")
              (lib.optional (tinymist' != null) (installWrapper tinymist' "tinymist"))
            ]
          )
        );
      mkDevShell =
        path:
        let
          config = {
            tinymist = true;
          }
          // (import "${path}/typst.nix" pkgs);
        in
        pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixd
            nixfmt
            (mkTypstWrapper config)
          ];
        };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixd
            nixfmt
          ];
        };
      };
    };
}
