{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, audioSupport ? true
, darwin
, alsa-lib

# passthru.tests.run
, runCommand
, uiua
}:

rustPlatform.buildRustPackage rec {
  pname = "uiua";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = "uiua-lang";
    repo = "uiua";
    rev = "refs/tags/${version}";
    hash = "sha256-USf1yZ0Gr9uhMgi3r9wR7EXU3ZrIKDJ/XXq75zypRMg=";
  };

  cargoHash = "sha256-UIY9QzkBhb96VvkIcvToolWdgrgSIVikKZPFZ28Azho=";

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    rustPlatform.bindgenHook
  ] ++ lib.optionals audioSupport [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ] ++ lib.optionals (audioSupport && stdenv.isDarwin) [
    darwin.apple_sdk.frameworks.AudioUnit
  ] ++ lib.optionals (audioSupport && stdenv.isLinux) [
    alsa-lib
  ];

  buildFeatures = lib.optional audioSupport "audio";

  passthru.tests.run = runCommand "uiua-test-run" {nativeBuildInputs = [uiua];} ''
    uiua init;
    diff -U3 --color=auto <(uiua run main.ua) <(echo '"Hello, World!"')
    touch $out;
  '';

  meta = with lib; {
    description = "A stack-oriented array programming language with a focus on simplicity, beauty, and tacit code";
    longDescription = ''
      Uiua combines the stack-oriented and array-oriented paradigms in a single
      language. Combining these already terse paradigms results in code with a very
      high information density and little syntactic noise.
    '';
    homepage = "https://www.uiua.org/";
    license = licenses.mit;
    mainProgram = "uiua";
    maintainers = with maintainers; [ cafkafk tomasajt ];
  };
}
