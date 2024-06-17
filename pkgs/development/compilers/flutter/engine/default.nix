{
  callPackage,
  dartSdkVersion,
  flutterVersion,
  version,
  hashes,
  url,
  patches,
  runtimeModes,
  isOptimized ? true,
  lib,
  stdenv,
  mainRuntimeMode ? null,
  altRuntimeMode ? null,
}@args:
let
  mainRuntimeMode = args.mainRuntimeMode or builtins.elemAt runtimeModes 0;
  altRuntimeMode = args.altRuntimeMode or builtins.elemAt runtimeModes 1;

  runtimeModesBuilds = lib.genAttrs runtimeModes (
    runtimeMode:
    callPackage ./package.nix {
      inherit
        dartSdkVersion
        flutterVersion
        version
        hashes
        url
        patches
        runtimeMode
        isOptimized
        ;
    }
  );
in
stdenv.mkDerivation (
  {
    pname = "flutter-engine";
    inherit url runtimeModes;
    inherit (runtimeModesBuilds.${mainRuntimeMode})
      meta
      src
      version
      dartSdkVersion
      isOptimized
      runtimeMode
      outName;
    inherit altRuntimeMode;

    dontUnpack = true;
    dontBuild = true;

    installPhase =
      ''
        mkdir -p $out/out
      ''
      + lib.concatMapStrings (
        runtimeMode:
        let
          runtimeModeBuild = runtimeModesBuilds.${runtimeMode};
          runtimeModeOut = runtimeModeBuild.outName;
        in
        ''
          ln -sf ${runtimeModeBuild}/out/${runtimeModeOut} $out/out/${runtimeModeOut}
        ''
      ) runtimeModes;
  }
  // runtimeModesBuilds
)
