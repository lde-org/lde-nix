#!/usr/bin/env bash

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$script_dir" || exit

if ! type nix-prefetch-url &>/dev/null; then
    echo "This tool requires nix-prefetch-url" >/dev/stderr
    exit 1
fi

nix_file="lde.nix"
repo="lde-org/lde"
releaseTag="$1"
if [ "$releaseTag" = "" ]; then
    # Get last tag
    releaseTag="$(
        git -c "versionsort.suffix=-" ls-remote --tags --sort="v:refname" \
            "https://github.com/$repo" | tail --lines=1 | cut --delimiter="/" --fields=3
    )"
fi

attrs() {
    indent="      "
    target="lde-$1-$2.zip"
    url="https://github.com/$repo/releases/download/$releaseTag/$target"
    echo "${indent}url = \"$url\";"
    sha256="$(nix-prefetch-url "$url" 2>/dev/null)"
    if [ "$sha256" = "" ]; then
        echo "No release found at $url" >/dev/stderr
        exit 1
    fi
    echo "${indent}sha256 = \"$sha256\";"
}

new_attrs_block=$(
    cat <<EOF
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "$releaseTag";
  platform_attrs = {
    "aarch64-darwin" = {
$(attrs macos aarch64)
    };
    "x86_64-darwin" = {
$(attrs macos x86-64)
    };
    "aarch64-linux" = {
$(attrs linux aarch64)
    };
    "x86_64-linux" = {
$(attrs linux x86-64)
    };
  };
  # GENERATED VERSION CONTROL - END
EOF
)

# AI generated command to update flake.nix automatically, AWK is really daunting
temp_file=$(mktemp)
awk -v new_block="$new_attrs_block" '
  /# GENERATED VERSION CONTROL - BEGIN/ {
    print new_block
    # Skip until the end marker
    while (getline > 0 && $0 !~ /# GENERATED VERSION CONTROL - END/) {}
    next
  }
  { print }
' "$nix_file" >"$temp_file"
mv "$temp_file" "$nix_file"
