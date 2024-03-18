{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verus";
  version = "0-unstable-2024-03-16";

  src = fetchFromGitHub {
    owner = "verus-lang";
    repo = pname;
    rev = "b73a992d131f0252c5af7417637800f6430281ed";
    hash = "sha256-fOx5WNb067dGUrDpIijTgGxA2RTmRotzg31VwGmMfwU=";
  };

  cargoHash = lib.fakeHash;
  cargoLock = {
    lockFile = "${src}/source/Cargo.lock";
  };
  # postUnpack = ''
  #   echo "HI ITS ME"
  #   ln -s $src/source/Cargo.lock $src/
  #   ls -al $src
  # '';


  meta = with lib; {
    description = "Verified Rust for low-level systems code";
    homepage = "https://github.com/verus-lang/verus/";
    license = licenses.mit;
    # maintainers = [ ];
  };
}

