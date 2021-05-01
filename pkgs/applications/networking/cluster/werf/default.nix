{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "werf";
  version = "1.2.9";
  subPackages = [ "cmd/werf" ];
  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
    sha256 = "0zkgjdlw3d5xh7g45bzxqspxr61ljdli8ng4a1k1gk0dls4sva8n";
  };
}
