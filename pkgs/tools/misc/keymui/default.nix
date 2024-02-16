{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  extra-cmake-modules,
  fontconfig,
  rust-jemalloc-sys,
  testers,
  keymui,
  nix-update-script,
  IOKit,
  CoreServices,
  CoreFoundation,
  glib,
  rustc,
  cargo,
  atk,
  gtk3,
}:
rustPlatform.buildRustPackage rec {
  pname = "keymui";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "semilin";
    repo = "keymui";
    rev = "558f95f135d229ba164f0900f7abc9fde8ea19a2";
    hash = "sha256-8STe+g3yBaQZNEzzEKdfrOnoYXQBHpV2Km7l5YfKnkA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "keycat-0.1.0" = "sha256-fE1P6qRQ8eNVxh2q6p4sDHwK6IcNG3t1QbY9ZrMx4uE=";
      "keymeow-0.1.0" = "sha256-Oan/KujPbbHncENtyulD+sHUt0w2bxSu+nK8Pgva+FE=";
    };
  };
  # RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    # rustPlatform.cargoSetupHook
    # rustPlatform.bindgenHook
    # rustc
    # cargo
    pkg-config
    # extra-cmake-modules
  ];
  buildInputs =
    [
      openssl
      glib
      atk
      gtk3
      # fontconfig
      # rust-jemalloc-sys
    ]
    ++ lib.optionals stdenv.isDarwin [
      IOKit
      CoreServices
      CoreFoundation
    ];

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://keymui.build/";
    maintainers = with maintainers; [dlip];
    license = licenses.mpl20;
  };
}
