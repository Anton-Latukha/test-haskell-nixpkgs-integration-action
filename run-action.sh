#!/usr/bin/env bash

rev=${rev:-'master'}

cabal2nix . > project-derivation.nix
curl -L "https://github.com/NixOS/nixpkgs/archive/$rev.tar.gz" | tar -xz
cd "nixpkgs-$rev" || exit 1

integrationPointFile='pkgs/development/haskell-modules/non-hackage-packages.nix'

# Remove black lines from the end of the file
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$integrationPointFile"
