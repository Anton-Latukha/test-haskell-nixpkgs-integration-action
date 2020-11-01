#!/usr/bin/env bash

ls

rev=${rev:-master}

projectDir=$(pwd)
echo "Project directory: $projectDir"

projectDirName=$(basename "$projectDir")
derivationName=integratedDerivation
projectDerivationFile=project-derivation.nix
cabal2nix .
cabal2nix . > "$projectDerivationFile"

ls

cat "$projectDerivationFile"

cd ..
echo "Now directory is ground dir: $(pwd)"

ls


# IDK why, but particularly inside CI Tar complains the stdin not being the tar archive, but then unarchives it, who would have thought.
curl -L "https://github.com/NixOS/nixpkgs/archive/$rev.tar.gz" | tar -xz
nixpkgsDir=nixpkgs-$rev
cd "$nixpkgsDir" || exit 1
echo "Now directory is Nixpkgs dir: $(pwd)"

ls

integrationPointFile=pkgs/development/haskell-modules/non-hackage-packages.nix

cp "$integrationPointFile" tmpFile
# Remove black lines from the end of the file
sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' tmpFile > "$integrationPointFile"
rm tmpFile

# Store the number of lines in the file
lineNumToInsertAt=$(wc -l "$integrationPointFile" | cut -f1 -d' ')

lineToInsert=" $derivationName = self.callPackage ../../../$projectDirName/$projectDerivationFile {};"
# Modify the file
cp "$integrationPointFile" tmpFile
sed "$lineNumToInsertAt"'i'"$lineToInsert" tmpFile > "$integrationPointFile"
rm tmpFile
cat "$integrationPointFile"

echo "Checking derivation file: $(type "$projectDir/$projectDerivationFile")"

nix-build . -A "haskellPackages.$derivationName"
