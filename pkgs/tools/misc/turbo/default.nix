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
  pname = "turbo";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "csapIeVB0FrLnmtUmLrRe8y54xmK50X30CV476DXEZI=";
  };

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
    HOME=$TMP

    # Test_getTraversePath requires that source is a git repo
    # pwd: /build/source/cli
    pushd ..
    git config --global init.defaultBranch main
    git init
    popd
  '';

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
