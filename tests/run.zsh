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

# run_brewshelf <formulas> <casks> [shell] — lists are newline-separated names
run_brewshelf() {
  print -rn -- "$1" > "$WORK/formulas"
  print -rn -- "$2" > "$WORK/casks"
  local shell=${3:-zsh}
  OUT=$(env -i HOME="$HOME" PATH="$TEST_PATH" \
    FAKE_BREW_FORMULAS="$WORK/formulas" FAKE_BREW_CASKS="$WORK/casks" \
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
check "shows the description" contains "JavaScript runtime (Node.js)"
check "lists casks" contains "ngrok"
check "counts formulas + casks" contains "Total: 4 packages installed"

print "unknown packages"
run_brewshelf $'node\nsome-unknown-formula' ''
check "puts unknown formulas under Other" contains "▶ Other / Dependencies"
check "lists the unknown formula" contains "some-unknown-formula"

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
