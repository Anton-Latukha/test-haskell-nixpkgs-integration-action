#!/usr/bin/env bash

rev="${rev:-master}"

projectDir="$(pwd)"
cabal2nix . > project-derivation.nix
derivationName='integratedDerivation'
cd ..
# IDK why, but particularly inside CI Tar complains the stdin not being the tar archive, but then unarchives it, who would have thought.
curl -L "https://github.com/NixOS/nixpkgs/archive/$rev.tar.gz" | tar -xz 2> /dev/null
nixpkgsDir="nixpkgs-$rev"
cd "$nixpkgsDir" || exit 1

integrationPointFile='pkgs/development/haskell-modules/non-hackage-packages.nix'

# Remove black lines from the end of the file
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$integrationPointFile"

# Store the number of lines in the file
lineNumToInsertAt="$(wc -l "$integrationPointFile" | cut -f1 -d' ')"

lineToInsert='  $derivationName = self.callPackage '"$projectDir"'/project-derivation.nix {};'
# Modify the file
sed -i "$lineNumToInsertAt"'i'"$lineToInsert" "$integrationPointFile"

cat "$projectDir/project-derivation.nix"
cat "$integrationPointFile"

nix-build . -A 'haskellPackages.'"$derivationName"
