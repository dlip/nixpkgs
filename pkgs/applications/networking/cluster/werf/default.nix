{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "werf";
  version = "1.2.10";

  goPackagePath = "github.com/werf/werf";
  subPackages = [ "cmd/werf" ];

  runVend = true;
  vendorSha256 = "";
  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "5af62f45a0df51b9af10fb8477392bd7236a208d";
    sha256 = "t0mETZdxaA4J0yHVZ+3A/9BUZ+L9hBNkDMGNQOgAg/A=";
  };
}
