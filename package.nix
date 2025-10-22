{
  lib,
  rust,
  makeRustPlatform,
  libGL,
  wayland,
  libxkbcommon,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust;
    rustc = rust;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "raphael-xiv";
  version = "0.22.3";

  doCheck = false;

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "non_contiguously_indexed_array-0.4.2" = "sha256-5x3jIAqNcRo1W3XfhtIcIwEcWeliSn+pcbpllQUclQA=";
    };
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "raphael-xiv";
      desktopName = "Raphael XIV";
      exec = "raphael-xiv";
    })
  ];

  postFixup = ''
    wrapProgram "$out/bin/raphael-xiv" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }"
  '';
}
