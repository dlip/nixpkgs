{ lib
, fetchFromGitHub
, buildGoModule
, git
, nodejs
, protobuf
, protoc-gen-go
, protoc-gen-go-grpc
}:

buildGoModule rec {
  pname = "go-turbo";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "YTuEv2S3jNV2o7HJML+P6OMazgwgRhUPnd/zaTWfDWs=";
  };

  modRoot = "cli";
  doCheck = false;

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
    HOME=$TMP

    # Test_getTraversePath requires that source is a git repo
    # pwd: /build/source/cli
    pushd ..
    git config --global init.defaultBranch main
    git init
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    dir="$GOPATH/bin"
    [ -e "$dir" ] && cp $dir/turbo $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
