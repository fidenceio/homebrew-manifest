#!/usr/bin/env bash
# Release gate — scaffolded by Manifest CLI (manifest init), scaffold-conformance tier.
#
# `manifest ship` refuses to release a repo without a verification gate
# (release_gate=local-tests, fail-closed) and auto-detects this script:
#   ./scripts/run-tests.sh --tier <smoke|full> --jobs N --no-cache
#
#   --tier smoke        baseline checks only (fast preflight)
#   --tier full         baseline + scaffold conformance (the release default)
#   --jobs, --no-cache  accepted for the ship contract; unused here
#
# The BASELINE section proves structural sanity (VERSION shape, shell syntax,
# JSON parse). SCAFFOLD CONFORMANCE certifies the repo's structural contract:
# required scaffold files exist and every structured contract file it declares
# (manifest.config.yaml, *.spec.yaml, k8s manifests, migrations) is well-formed.
# This is an honest, passing gate for a well-formed scaffold and fails if the
# scaffold is broken. It does NOT claim the code works — this repo has none yet.
# When real code lands, add its suite alongside:  run_check <build/test command>

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

# ------------------------------------------------------- SCAFFOLD CONFORMANCE
# Certify the structural contract. Extend with real build/test checks as code
# lands (run_check <cmd>); those compose with the conformance checks below.

if [ "$TIER" = "full" ]; then

    # Required scaffold files — every fleet member carries these.
    for req in README.md CHANGELOG.md VERSION .gitignore; do
        if [ -e "$req" ]; then ok "present: $req"; else bad "required scaffold file missing: $req"; fi
    done

    # Well-formedness of every declared YAML contract file. Uses a real parser
    # when one is present (yq, then python3+PyYAML); otherwise a dependency-free
    # sanity check (non-empty, no tab indentation — a hard YAML error). Never
    # installs anything.
    TAB="$(printf '\t')"
    yaml_ok() {
        [ -s "$1" ] || return 1
        if command -v yq >/dev/null 2>&1; then
            yq -e '.' "$1" >/dev/null 2>&1
            return
        fi
        if command -v python3 >/dev/null 2>&1 && python3 -c 'import yaml' >/dev/null 2>&1; then
            python3 -c 'import sys,yaml; list(yaml.safe_load_all(open(sys.argv[1])))' "$1" >/dev/null 2>&1
            return
        fi
        ! grep -q "^${TAB}" "$1"
    }
    yaml_total=0 yaml_bad=0
    while IFS= read -r f; do
        [ -n "$f" ] || continue
        yaml_total=$((yaml_total+1))
        yaml_ok "$f" || { bad "malformed YAML: $f"; yaml_bad=$((yaml_bad+1)); }
    done < <(list_files '*.yaml'; list_files '*.yml')
    if [ "$yaml_total" -gt 0 ]; then
        [ "$yaml_bad" -eq 0 ] && ok "YAML parse ($yaml_total file(s) checked)"
    else
        note "no YAML contract files declared"
    fi

    # Migration repos: migrations/ must actually carry SQL.
    if [ -d migrations ]; then
        mig_total=0
        while IFS= read -r f; do [ -n "$f" ] && mig_total=$((mig_total+1)); done < <(list_files '*.sql')
        if [ "$mig_total" -gt 0 ]; then ok "migrations ($mig_total .sql file(s))"; else bad "migrations/ present but no .sql files"; fi
    fi

fi

echo ""
if [ "$FAILED" -ne 0 ]; then
    echo "run-tests: FAIL (tier: $TIER)"
    exit 1
fi
echo "run-tests: PASS (tier: $TIER)"
