# darkone@darkone.yt

set shell := ["bash", "-euo", "pipefail", "-c"]

alias c := clean

# Check and clean nix files
clean:
	#!/usr/bin/env bash
	statix fix .
	find . -name "*.nix" -exec nixfmt -s {} \;
