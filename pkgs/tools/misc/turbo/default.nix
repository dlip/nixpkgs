{ lib, fetchFromGitHub, buildGoModule, git, nodejs, protobuf, protoc-gen-go, protoc-gen-go-grpc }:
buildGoModule rec {
  pname = "turbo";
  version = "1.6.3";

  src = "${fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "csapIeVB0FrLnmtUmLrRe8y54xmK50X30CV476DXEZI=";
  }}/cli";

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

  # One test failing due to nix build environment: Test_getTraversePath/From_fixture_location
  doCheck = false;

  meta = with lib; {
    description = "Turborepo is a high-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
