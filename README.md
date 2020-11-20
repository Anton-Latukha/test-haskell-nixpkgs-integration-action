# Automatic Haskell project Nixpkgs integration test

GitHub CI action.

Runs the automatic integration & build of the project inside Nixpkgs store.

Test is equivalent to the process of projects Hackage release and its automatic Nixpkgs import of it into the store.

Main agenda of the test is to ensure on the result of the Hackage release to Nixpkgs pipeline autointegration before making the Hackage release.

Ready installation:

`.github/workflows/Nixpkgs-integration.yml`:
```yaml
name: "Direct import & build inside Nixpkgs"

on:
  release:
    # "created" - on {draft, pre-release, release} creation
    types: [ created ]

jobs:

  build10:
    name: "Integration test"
    runs-on: ubuntu-latest

    steps:
    - name: "Git checkout"
      uses: actions/checkout@v2

    - name: "Local cache"
      uses: actions/cache@v2
      with:
        path: |
          /nix/store
        key: ${{ runner.os }}-Nixpkgs-integration-test

    - name: "Install Nix"
      uses: cachix/install-nix-action@v12
      with:
        nix_path: "nixpkgs=channel:nixos-unstable"

    - name: "Run Nixpkgs integration test"
      uses: Anton-Latukha/test-haskell-nixpkgs-integration-action@v1
      # Optionally declare the Nixpkgs revision, by default Nixpkgs "master" is used to run the integration.
      with:
        rev: "master"
```

If test fails - the project needs derivation customization inside Nixpkgs, most probably in `NixOS/nixpkgs: pkgs/development/haskell-modules/configuration-common.nix`.
Links:
  - [Official Haskell Nixpkgs manual on it](https://haskell4nix.readthedocs.io/nixpkgs-developers-guide.html#fixing-broken-haskell-packages).
  - [Peti's video "How to Fix Broken Haskell Packages in Nix"](https://www.youtube.com/watch?v=KLhkAEk8I20).
