#!/usr/bin/env zsh

mythx analyze \
  --api-key $MYTHX_KEY \
  --remap-import "@openzeppelin/=$(pwd)/node_modules/@openzeppelin/" \
  --output mythos-scan-output.json \
  contracts
