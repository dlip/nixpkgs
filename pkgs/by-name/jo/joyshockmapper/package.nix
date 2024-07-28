{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  libappindicator-gtk3,
  libevdev,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  xorg,
  lerc,
  libxkbcommon,
  epoxy,
  libXtst,
  SDL2,
  libjoyshock,
  magic-enum,
}:
stdenv.mkDerivation rec {
  pname = "joyshockmapper";
  version = "3.5.4";

  pocketfsm = fetchFromGitHub {
    owner = "Electronicks";
    repo = "Pocket_FSM";
    rev = "e447ec24c7a547bd1fbe8d964baa866a9cf146c8";
    hash = "sha256-/dvOMEV9mduqk+BVpUqtdVGAEHIDmiQOIjMZPDzABRs=";
  };
  gamepadmotionhelpers = fetchFromGitHub {
    owner = "JibbSmart";
    repo = "GamepadMotionHelpers";
    rev = "39b578aacf34c3a1c584d8f7f194adc776f88055";
    hash = "sha256-yEEcjUzXQAyc/3STuH7Yhbl5r+/S+M15AxNDEbhJuAY=";
  };
  src = fetchFromGitHub {
    owner = "Electronicks";
    repo = "JoyShockMapper";
    rev = "v${version}";
    hash = "sha256-zoiSnVLDUeQ0oxJ9yns8OX3dMxgCHrUu2f0JWZqm1K8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gtk3
    libappindicator-gtk3
    libevdev
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    lerc
    libxkbcommon
    pcre2
    epoxy
    libXtst
    SDL2
    SDL2.dev
    libjoyshock
    magic-enum
  ];

  postUnpack = ''
    pushd "$sourceRoot/JoyShockMapper"
    cp --no-preserve=mode,ownership ${pocketfsm}/include/* include
    cp --no-preserve=mode,ownership ${gamepadmotionhelpers}/GamepadMotion.hpp include
    popd
  '';

  patches = [
    ./cmake.patch
  ];

  buildInputs = [
  ];

  meta = with lib; {
    description = "A tool for PC gamers to play games with DualShock 4s, JoyCons, and Pro Controllers. Gyro aiming, flick stick";
    homepage = "https://github.com/Electronicks/JoyShockMapper";
    changelog = "https://github.com/Electronicks/JoyShockMapper/blob/${src.rev}/CHANGELOG.md";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "joyshockmapper";
    platforms = platforms.all;
  };
}
