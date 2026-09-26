#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$script_dir" || exit

# Fetch the Nix base32 sha256 of a URL.
#
# Prefers nix-prefetch-url, which needs a writable /nix/store. Hosts running
# without a nix-daemon (or with a store owned by another user) cannot use it, so
# fall back to hashing a plain download instead. Both paths yield the same hash.
fetch_sha256() {
    url="$1"
    hash=""

    if type nix-prefetch-url &>/dev/null; then
        hash="$(nix-prefetch-url "$url" 2>/dev/null)" || hash=""
        if [ -n "$hash" ]; then
            printf '%s\n' "$hash"
            return 0
        fi
    fi

    if type curl &>/dev/null && type nix &>/dev/null; then
        tmp_file="$(mktemp)"
        if curl --fail --silent --show-error --location --output "$tmp_file" "$url"; then
            hash="$(nix hash file --type sha256 --base32 "$tmp_file" 2>/dev/null)" || hash=""
        fi
        rm --force "$tmp_file"
        if [ -n "$hash" ]; then
            printf '%s\n' "$hash"
            return 0
        fi
    fi

    return 1
}

nix_file="lde.nix"
repo="lde-org/lde"
releaseTag="${1:-}"
if [ "$releaseTag" = "" ]; then
    # Get last tag
    releaseTag="$(
        git -c "versionsort.suffix=-" ls-remote --tags --sort="v:refname" \
            "https://github.com/$repo" | tail --lines=1 | cut --delimiter="/" --fields=3
    )"
    if [ "$releaseTag" = "" ]; then
        echo "Could not determine the latest tag of $repo" >/dev/stderr
        exit 1
    fi
fi

# Fetch one hash, complaining loudly when the asset is missing.
#
# This is deliberately called at the top level rather than from inside the
# command substitution below: `exit 1` only leaves the subshell it runs in, so
# failing inside $(attrs ...) would let the script carry on and write a block
# with empty hashes over the good file.
fetch() {
    target_url="$1"
    if ! hash="$(fetch_sha256 "$target_url")"; then
        echo "No release found at $target_url" >/dev/stderr
        return 1
    fi
    printf '%s\n' "$hash"
}

release_url() {
    printf 'https://github.com/%s/releases/download/%s/lde-%s-%s.zip\n' \
        "$repo" "$releaseTag" "$1" "$2"
}

url_macos_aarch64="$(release_url macos aarch64)"
url_macos_x86_64="$(release_url macos x86-64)"
url_linux_aarch64="$(release_url linux aarch64)"
url_linux_x86_64="$(release_url linux x86-64)"

sha_macos_aarch64="$(fetch "$url_macos_aarch64")" || exit 1
sha_macos_x86_64="$(fetch "$url_macos_x86_64")" || exit 1
sha_linux_aarch64="$(fetch "$url_linux_aarch64")" || exit 1
sha_linux_x86_64="$(fetch "$url_linux_x86_64")" || exit 1

new_attrs_block=$(
    cat <<EOF
  # GENERATED VERSION CONTROL - BEGIN
  releaseTag = "$releaseTag";
  platform_attrs = {
    "aarch64-darwin" = {
      url = "$url_macos_aarch64";
      sha256 = "$sha_macos_aarch64";
    };
    "x86_64-darwin" = {
      url = "$url_macos_x86_64";
      sha256 = "$sha_macos_x86_64";
    };
    "aarch64-linux" = {
      url = "$url_linux_aarch64";
      sha256 = "$sha_linux_aarch64";
    };
    "x86_64-linux" = {
      url = "$url_linux_x86_64";
      sha256 = "$sha_linux_x86_64";
    };
  };
  # GENERATED VERSION CONTROL - END
EOF
)

# AI generated command to update lde.nix automatically, AWK is really daunting
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

echo "Updated $nix_file to $releaseTag"
