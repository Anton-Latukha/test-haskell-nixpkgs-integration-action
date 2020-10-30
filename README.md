# Automatic Nixpkgs integration test for Haskell projects

GitHub Action that runs the integration of the project in Nixpkgs store.

Test ensures that project after the Hackage release would properly autointegrate through the Nixpkgs pipeline into Nixpkgs.

Requires to trun Nix being installed before it.
Example of use:
```yaml
- name: Install Nix
  uses: cachix/install-nix-action@v11
  with:
    nix_path: "nixpkgs=channel:nixos-unstable"

- name: Run Nixpkgs integration test
  uses: Anton-Latukha/test-haskell-nixpkgs-integration-action
```

Available options:

```yaml
  # Optionally declare the Nixpkgs revision, by default Nixpkgs "master" is used to run integration.
  with:
    rev: "master"
```
