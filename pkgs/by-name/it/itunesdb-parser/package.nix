{ lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iTunesDB-Parser";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "raleighlittles";
    repo = "iTunesDB-Parser";
    rev = "4cbf618ea8d293c4053cf7fb4c0e68980af783f5";
    hash = "sha256-i4Ph/tKykWhp5PXuRaNS9lDKhMLU2oKeQjrtjiPIkrM=";
  };

  sourceRoot = "${src.name}/parser";
  cargoPatches = [ ./add-Cargo-lock.patch ];

  cargoHash = "sha256-nllOWKlGFOmc+tnlHc2TIps3SSs3jUg3aGVKB8gsMdc=";

  meta = {
    description = "itunes database parsing";
    homepage = "";
    changelog = "";
    license = with lib.licenses; [
      unfree
    ];
    maintainers = with lib.maintainers; [
      atar13
    ];
    mainProgram = "rg";
    platforms = lib.platforms.all;
  };
}
