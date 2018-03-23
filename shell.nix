{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.ghcWithPackages (hs: with hs; [ base bytestring containers ghc-prof-flamegraph ])
