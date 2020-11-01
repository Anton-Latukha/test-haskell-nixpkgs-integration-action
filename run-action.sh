#!/usr/bin/env bash
rev=${rev:-master}

projectDir=$(pwd)
projectDirName=$(basename "$projectDir")
derivationName=integratedDerivation
projectDerivationFile=project-derivation.nix

cabal2nix . > "$projectDerivationFile"

cd ..

# Loading Nixpkgs
curl -L "https://github.com/NixOS/nixpkgs/archive/$rev.tar.gz" | tar -xz
nixpkgsDir=nixpkgs-$rev
cd "$nixpkgsDir" || exit 1

integrationPointFile=pkgs/development/haskell-modules/non-hackage-packages.nix

# Remove black lines from the end of the file
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$integrationPointFile"

# Store the number of lines in the file
lineNumToInsertAt=$(wc -l "$integrationPointFile" | cut -f1 -d' ')

# Modify the file
lineToInsert=" $derivationName = self.callPackage ../../../../$projectDirName/$projectDerivationFile {};"
sed -i "$lineNumToInsertAt"'i'"$lineToInsert" "$integrationPointFile"

nix-build . -A "haskellPackages.$derivationName"
