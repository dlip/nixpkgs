{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "werf";
  version = "1.2.10";

  goPackagePath = "github.com/werf/werf";
  subPackages = [ "cmd/werf" ];
  doCheck = false;

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "5af62f45a0df51b9af10fb8477392bd7236a208d";
    sha256 = "0zkgjdlw3d5xh7g45bzxqspxr61ljdli8ng4a1k1gk0dls4sva8n";
  };
}
