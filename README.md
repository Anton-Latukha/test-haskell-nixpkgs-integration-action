# Automatic Haskell project Nixpkgs integration test

GitHub CI action.

Runs the automatic integration & build of the project inside Nixpkgs store.

Example of use:
`.github/workflows/Nixpkgs-integration.yml`
```yaml
name: "Direct import & build inside Nixpkgs"

on:
  pull_request:
  push:
    branches:
      - master

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
