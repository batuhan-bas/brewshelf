#!/usr/bin/env zsh
# Runs brewshelf.sh against a fake `brew` (tests/bin/brew) and checks the output.
# Usage: zsh tests/run.zsh

TESTS_DIR=${0:A:h}
SCRIPT=${TESTS_DIR:h}/brewshelf.sh
WORK=$(mktemp -d)
trap 'rm -rf -- "$WORK"' EXIT

# Only the fake brew and system tools — the real Homebrew must not leak in
TEST_PATH="$TESTS_DIR/bin:/usr/bin:/bin"

typeset -i passed=0 failed=0
OUT="" STATUS=0

# What `brew info --json=v2 --installed` returns. "untrusted-formula" is missing on purpose:
# Homebrew leaves out formulas from untrusted taps and formulas removed from Homebrew.
cat > "$WORK/info.json" <<'JSON'
{
  "formulae": [
    { "name": "node", "desc": "Open-source, cross-platform JavaScript runtime environment" },
    { "name": "ffmpeg", "desc": "Play, record, convert, and stream audio and video" },
    { "name": "sqlite", "desc": "Command-line interface for SQLite" },
    { "name": "some-unknown-formula", "desc": "Formula without a category" },
    { "name": "multiline", "desc": "First line\tand a tab\nsecond line" }
  ],
  "casks": [
    { "token": "ngrok", "desc": "Reverse proxy, secure introspectable tunnels to localhost" }
  ]
}
JSON

# Extra environment for the next run_brewshelf call, e.g. (BREWSHELF_JSON_PARSER=osascript)
typeset -a EXTRA_ENV=()

# run_brewshelf <formulas> <casks> [shell] — lists are newline-separated names
run_brewshelf() {
  print -rn -- "$1" > "$WORK/formulas"
  print -rn -- "$2" > "$WORK/casks"
  local shell=${3:-zsh}
  OUT=$(env -i HOME="$HOME" PATH="$TEST_PATH" \
    FAKE_BREW_FORMULAS="$WORK/formulas" FAKE_BREW_CASKS="$WORK/casks" \
    FAKE_BREW_JSON="$WORK/info.json" "${EXTRA_ENV[@]}" \
    "$shell" "$SCRIPT" 2>&1)
  STATUS=$?
  # Strip ANSI colors so assertions match plain text
  OUT=$(print -r -- "$OUT" | sed $'s/\e\\[[0-9;]*m//g')
}

check() {
  local description=$1; shift
  if "$@"; then
    (( passed++ ))
    print "  ✔ $description"
  else
    (( failed++ ))
    print "  ✖ $description"
    print -r -- "$OUT" | sed 's/^/      │ /'
  fi
}

contains()     { [[ "$OUT" == *"$1"* ]] }
not_contains() { [[ "$OUT" != *"$1"* ]] }
status_is()    { (( STATUS == $1 )) }

print "syntax"
check "brewshelf.sh parses with zsh -n" zsh -n "$SCRIPT"

print "known packages"
run_brewshelf $'node\nffmpeg\nsqlite' $'ngrok'
check "exits 0" status_is 0
check "groups formulas by category" contains "▶ Development"
check "shows the Homebrew description" contains "Open-source, cross-platform JavaScript runtime environment"
check "lists casks" contains "ngrok"
check "shows the cask description" contains "Reverse proxy, secure introspectable tunnels to localhost"
check "counts formulas + casks" contains "Total: 4 packages installed"

print "unknown packages"
run_brewshelf $'node\nsome-unknown-formula' ''
check "puts unknown formulas under Other" contains "▶ Other / Dependencies"
check "lists the unknown formula" contains "some-unknown-formula"
check "describes the unknown formula too" contains "Formula without a category"

print "descriptions"
run_brewshelf $'node\nuntrusted-formula' ''
check "lists a formula missing from brew info" contains "untrusted-formula"
check "still counts it" contains "Total: 2 packages installed"
run_brewshelf $'multiline' ''
check "flattens tabs and newlines in descriptions" contains "First line and a tab second line"
EXTRA_ENV=(FAKE_BREW_INFO_FAILS=1)
run_brewshelf $'node' ''
check "brew info failing: exits 0" status_is 0
check "brew info failing: still lists packages" contains "node"
EXTRA_ENV=()

print "JSON parsers"
for parser in jq osascript; do
  if [[ $parser == jq ]] && ! PATH=$TEST_PATH command -v jq >/dev/null; then
    print "  - jq not installed, skipped"
    continue
  fi
  EXTRA_ENV=(BREWSHELF_JSON_PARSER=$parser)
  run_brewshelf $'node\nsome-unknown-formula' $'ngrok'
  check "$parser: formula description" contains "Open-source, cross-platform JavaScript runtime environment"
  check "$parser: cask description" contains "Reverse proxy, secure introspectable tunnels to localhost"
done
EXTRA_ENV=()

print "no casks"
run_brewshelf $'node' ''
check "skips the casks section" not_contains "GUI Applications"
check "does not count a phantom cask" contains "Total: 1 package installed"

print "nothing installed"
run_brewshelf '' ''
check "exits 0" status_is 0
check "says nothing is installed" contains "No Homebrew packages installed."
check "prints no shelf" not_contains "Total:"

print "Homebrew missing"
OUT=$(env -i HOME="$HOME" PATH="/usr/bin:/bin" zsh "$SCRIPT" 2>&1); STATUS=$?
check "exits 1" status_is 1
check "explains that Homebrew is missing" contains "Homebrew not found"

print "wrong shell"
run_brewshelf $'node' '' bash
check "bash: exits 1" status_is 1
check "bash: asks for zsh" contains "requires zsh"

print ""
print "$passed passed, $failed failed"
(( failed == 0 ))
