{ lib
, fetchFromGitHub
, buildGoModule
, git
, nodejs
, protobuf
, protoc-gen-go
, protoc-gen-go-grpc
, rustPlatform
, pkg-config
, openssl
, extra-cmake-modules
, fontconfig
}:
let
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "YTuEv2S3jNV2o7HJML+P6OMazgwgRhUPnd/zaTWfDWs=";
  };

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };

  go-turbo = buildGoModule rec {
    inherit src version meta;
    pname = "go-turbo";
    modRoot = "cli";

    vendorSha256 = "Kx/CLFv23h2TmGe8Jwu+S3QcONfqeHk2fCW1na75c0s=";

    nativeBuildInputs = [
      git
      nodejs
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    preBuild = ''
      make compile-protos
    '';

    preCheck = ''
      # Some tests try to run mkdir $HOME
      HOME=$(mktemp -d)

      # Test_getTraversePath requires that source is a git repo
      # pwd: /build/source/cli
      pushd ..
      git config --global init.defaultBranch main
      git init
      popd
    '';

  };
in
# Error: `#![feature]` may not be used on the stable release channel
rustPlatform.buildRustPackage rec {
  pname = "turbo";
  inherit src version meta;
  cargoSha256 = "ENw6NU3Fedd+OJEEWgL8A54aowNqjn3iv7rxlr+/4ZE=";
  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
  ];
  buildInputs = [
    openssl
    fontconfig
  ];

  postBuild = ''
    cp ${go-turbo}/bin/turbo $out/bin/go-turbo
  '';
}
