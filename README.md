# test-haskell-nixpkgs-integration-action
GitHub Action that actively tests the project abilty to integrate and work in current official Nixpkgs environemt

Since there are differences between the projet-local and result derivations projects build in the Nixpkgs.

Test ensures that project after the Hackage release would properly autointegrate through the pipeline into Nixpkgs.

Requires Nix/`cachix/install-nix-action` being installed before it, AKA, please add a run step:
```yaml
- name: Install Nix
  uses: cachix/install-nix-action@v10
```
