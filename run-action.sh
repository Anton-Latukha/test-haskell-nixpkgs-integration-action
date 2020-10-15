#!/usr/bin/env bash

rev=${rev:-'master'}

cabal2nix . > project-derivation.nix
