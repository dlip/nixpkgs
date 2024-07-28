{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  libappindicator-gtk3,
  libevdev,
  pcre,
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
  magic-enum,
}:
clangStdenv.mkDerivation rec {
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

  strictDeps = true;
  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [
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
    pcre
    pcre2
    epoxy
    libXtst
    SDL2
    magic-enum
  ];

  # NIX_LDFLAGS = ''
  #   -rpath ${libevdev.out}/lib
  #   -rpath ${gtk3.out}/lib
  #   -rpath ${gtk3.dev}/lib
  #   -rpath ${SDL2.out}/lib
  #   -rpath ${SDL2.dev}/lib
  #   -rpath ${libappindicator-gtk3.out}/lib
  #   -rpath ${libappindicator-gtk3.dev}/lib
  # '';

  # NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath nativeBuildInputs}";

  # installFlags = [
  #   "PREFIX=${placeholder "out"}"
  #   "CPPFLAGS=$NIX_CFLAGS_COMPILE"
  #   "LDFLAGS=$NIX_LDFLAGS"
  # ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "CPPFLAGS=$NIX_CFLAGS_COMPILE"
    "LDFLAGS=$NIX_LDFLAGS"
  ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I ${SDL2.dev}/include/SDL2 -I ${libevdev}/include/libevdev-1.0 $(pkg-config --cflags gtk+-3.0 appindicator3-0.1)"
    # echo $NIX_CFLAGS_COMPILE


    # echo ${libevdev}
    # pkg-config --cflags --libs gtk+-3.0
    # pkg-config  --list-all | grep pcre
    # echo $NIX_LDFLAGS
    # exit 1
  '';
  postUnpack = ''
    pushd "$sourceRoot/JoyShockMapper"
    cp --no-preserve=mode,ownership ${pocketfsm}/include/* include
    cp --no-preserve=mode,ownership ${gamepadmotionhelpers}/GamepadMotion.hpp include
    popd
  '';

  patches = [
    ./cmake.patch
  ];

  meta = with lib; {
    description = "A tool for PC gamers to play games with DualShock 4s, JoyCons, and Pro Controllers. Gyro aiming, flick stick";
    homepage = "https://github.com/Electronicks/JoyShockMapper";
    changelog = "https://github.com/Electronicks/JoyShockMapper/blob/${src.rev}/CHANGELOG.md";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "joyshockmapper";
    platforms = platforms.all;
    pkgConfigModules = [
      "gtk+-3.0"
    ];
  };
}
