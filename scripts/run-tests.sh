#!/usr/bin/env bash
# Release gate — scaffolded by Manifest CLI (manifest init).
#
# `manifest ship` refuses to release a repo without a verification gate
# (release_gate=local-tests, fail-closed) and auto-detects this script:
#   ./scripts/run-tests.sh --tier <smoke|full> --jobs N --no-cache
#
#   --tier smoke        baseline checks only (fast preflight)
#   --tier full         baseline + project checks (the release default)
#   --jobs, --no-cache  accepted for the ship contract; unused here
#
# The BASELINE section proves structural sanity (VERSION shape, shell syntax,
# JSON parse). It is NOT a substitute for real tests — extend the PROJECT
# CHECKS section with this repo's actual suite as it grows.

set -uo pipefail

TIER="full"
while [ $# -gt 0 ]; do
    case "$1" in
        --tier)   shift; TIER="${1:-full}" ;;
        --tier=*) TIER="${1#--tier=}" ;;
        --jobs)   shift ;;
    esac
    [ $# -gt 0 ] && shift
done

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 2

FAILED=0
note() { printf '  %s\n' "$*"; }
ok()   { printf 'ok    %s\n' "$*"; }
bad()  { printf 'FAIL  %s\n' "$*"; FAILED=1; }
run_check() {
    printf 'run   %s\n' "$*"
    if "$@"; then ok "$*"; else bad "$*"; fi
}

# Tracked files by pattern — git's view when available, pruned find otherwise.
list_files() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        git ls-files -- "$1" 2>/dev/null
    else
        find . -type d \( -name .git -o -name node_modules -o -name target \
            -o -name dist -o -name build -o -name .next -o -name vendor \) -prune \
            -o -type f -name "$1" -print | sed 's|^\./||'
    fi
}

# ------------------------------------------------------------------ BASELINE

if [ -f VERSION ]; then
    v="$(tr -d '[:space:]' < VERSION)"
    if printf '%s' "$v" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+([-+.][0-9A-Za-z.+-]*)?$'; then
        ok "VERSION ($v)"
    else
        bad "VERSION is not semver-shaped: '$v'"
    fi
else
    bad "VERSION file missing"
fi

sh_total=0 sh_bad=0
while IFS= read -r f; do
    [ -n "$f" ] || continue
    sh_total=$((sh_total+1))
    bash -n "$f" 2>/dev/null || { bad "shell syntax: $f"; sh_bad=$((sh_bad+1)); }
done < <(list_files '*.sh')
[ "$sh_bad" -eq 0 ] && ok "shell syntax ($sh_total file(s) checked)"

if command -v jq >/dev/null 2>&1; then
    json_total=0 json_bad=0
    while IFS= read -r f; do
        [ -n "$f" ] || continue
        json_total=$((json_total+1))
        jq -e . "$f" >/dev/null 2>&1 || { bad "invalid JSON: $f"; json_bad=$((json_bad+1)); }
    done < <(list_files '*.json')
    [ "$json_bad" -eq 0 ] && ok "JSON parse ($json_total file(s) checked)"
else
    note "jq not installed - skipping JSON parse check"
fi

# ------------------------------------------------------------- PROJECT CHECKS
# Detected at scaffold time from the repo layout. This section is yours:
# replace or extend it with the repo's real test suite.

if [ "$TIER" = "full" ]; then
    bad "no build or test verification is declared by this repo — the release gate cannot certify it"
    note "A passing gate here would claim \"verified\" without verifying anything. Do ONE of:"
    note "  1. add your real check above:  run_check <build/test command>"
    note "  2. point the gate elsewhere:   set release_gate_command (MANIFEST_CLI_RELEASE_GATE_COMMAND)"
    note "  3. bypass deliberately:         set release_gate=none (audited, unverified)"
fi

echo ""
if [ "$FAILED" -ne 0 ]; then
    echo "run-tests: FAIL (tier: $TIER)"
    exit 1
fi
echo "run-tests: PASS (tier: $TIER)"
