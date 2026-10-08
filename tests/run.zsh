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
    { "name": "node", "desc": "Open-source, cross-platform JavaScript runtime environment",
      "installed": [{ "installed_on_request": true }] },
    { "name": "ffmpeg", "desc": "Play, record, convert, and stream audio and video",
      "installed": [{ "installed_on_request": true }] },
    { "name": "sqlite", "desc": "Command-line interface for SQLite",
      "installed": [{ "installed_on_request": true }] },
    { "name": "some-unknown-formula", "desc": "Formula without a category",
      "installed": [{ "installed_on_request": true }] },
    { "name": "multiline", "desc": "First line\tand a tab\nsecond line",
      "installed": [{ "installed_on_request": true }] },
    { "name": "libvpx", "desc": "VP8/VP9 video codec",
      "installed": [{ "installed_on_request": false }] },
    { "name": "no-desc-dep", "desc": null,
      "installed": [{ "installed_on_request": false }] },
    { "name": "sdl2-compat", "desc": "SDL2 compatibility layer", "aliases": ["sdl2"],
      "installed": [{ "installed_on_request": false }] },
    { "name": "new-name", "desc": "Formula that was renamed", "oldnames": ["old-name"],
      "installed": [{ "installed_on_request": true }] }
  ],
  "casks": [
    { "token": "ngrok", "desc": "Reverse proxy, secure introspectable tunnels to localhost" }
  ]
}
JSON

# Extra environment for the next run_brewshelf call, e.g. (BREWSHELF_JSON_PARSER=osascript)
typeset -a EXTRA_ENV=()

# run_brewshelf <formulas> <casks> [shell [args...]] — lists are newline-separated names
run_brewshelf() {
  print -rn -- "$1" > "$WORK/formulas"
  print -rn -- "$2" > "$WORK/casks"
  local shell=${3:-zsh}
  local -a args=("${@:4}")
  OUT=$(env -i HOME="$HOME" PATH="$TEST_PATH" \
    FAKE_BREW_FORMULAS="$WORK/formulas" FAKE_BREW_CASKS="$WORK/casks" \
    FAKE_BREW_JSON="$WORK/info.json" "${EXTRA_ENV[@]}" \
    "$shell" "$SCRIPT" "${args[@]}" 2>&1)
  STATUS=$?
  OUT_RAW=$OUT
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
contains_raw() { [[ "$RAW" == *"$1"* ]] }
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
check "puts unknown formulas under Other" contains "▶ Other"
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

print "renamed formulas"
# `brew list` shows the name a formula was installed under; brew info uses the current name
run_brewshelf $'node\nsdl2\nold-name' ''
check "alias: recognized as a dependency and hidden" not_contains "sdl2"
check "oldname: described" contains "Formula that was renamed"
run_brewshelf $'node\nsdl2' '' zsh --all
check "alias: described with --all" contains "(dependency) SDL2 compatibility layer"

print "formatting"
run_brewshelf $'node\nuntrusted-formula\nno-desc-dep' $'ngrok' zsh --all
no_trailing_space() { ! print -r -- "$OUT" | grep -qE ' +$' }
check "no line ends with whitespace" no_trailing_space
check "dependency without description: label only" contains "(dependency)"

print "dependencies"
run_brewshelf $'node\nlibvpx\nno-desc-dep' ''
check "hides dependencies by default" not_contains "libvpx"
check "hides a dependency without description" not_contains "no-desc-dep"
check "still counts them" contains "Total: 3 packages installed"
check "says how many are hidden" contains "2 dependencies hidden — run 'brewshelf --all'"
check "keeps requested formulas" contains "node"
run_brewshelf $'node\nuntrusted-formula' ''
check "shows formulas missing from brew info (cannot tell)" contains "untrusted-formula"
check "no hidden note when nothing is hidden" not_contains "hidden"
run_brewshelf $'node\nlibvpx\nno-desc-dep' '' zsh --all
check "--all: shows dependencies" contains "libvpx"
check "--all: with their description" contains "VP8/VP9 video codec"
check "--all: shows a dependency without description" contains "no-desc-dep"
check "--all: labels dependencies (no colors when piped)" contains "(dependency) VP8/VP9 video codec"
check "--all: no dimmed-names note without colors" not_contains "Dimmed names"
check "--all: no hidden note" not_contains "hidden"

print "options"
run_brewshelf $'node' '' zsh --bogus
check "unknown option: exits 2" status_is 2
check "unknown option: names it" contains "unknown option '--bogus'"
check "unknown option: points to --help" contains "brewshelf --help"
for flag in --help -h; do
  run_brewshelf $'node' '' zsh $flag
  check "$flag: exits 0" status_is 0
  check "$flag: shows usage" contains "Usage: brewshelf [options]"
done
for flag in --version -v; do
  run_brewshelf $'node' '' zsh $flag
  check "$flag: prints the version" contains "brewshelf 1."
done
OUT=$(env -i HOME="$HOME" PATH="/usr/bin:/bin" zsh "$SCRIPT" --help 2>&1); STATUS=$?
check "--help works without Homebrew" status_is 0
run_brewshelf $'node\nlibvpx' '' zsh -a
check "-a works like --all" contains "libvpx"

print "colors"
# run_tty <args...> — runs brewshelf in a pseudo-terminal, keeping ANSI codes in RAW
run_tty() {
  print -rn -- $'node\nlibvpx' > "$WORK/formulas"
  print -rn -- '' > "$WORK/casks"
  RAW=$(env -i HOME="$HOME" PATH="$TEST_PATH" TERM=xterm \
    FAKE_BREW_FORMULAS="$WORK/formulas" FAKE_BREW_CASKS="$WORK/casks" \
    FAKE_BREW_JSON="$WORK/info.json" "${EXTRA_ENV[@]}" \
    script -q /dev/null zsh "$SCRIPT" "$@" < /dev/null 2>&1)
}
has_ansi() { [[ "$RAW" == *$'\e['* ]] }
no_ansi()  { [[ "$RAW" != *$'\e['* ]] }
run_brewshelf $'node' ''
RAW=$OUT_RAW
check "no colors when piped" no_ansi
run_tty
check "colors in a terminal" has_ansi
run_tty --all
check "terminal --all: explains dimmed names" contains_raw "Dimmed names were installed as dependencies"
run_tty --no-color
check "--no-color: no colors in a terminal" no_ansi
EXTRA_ENV=(NO_COLOR=1)
run_tty
check "NO_COLOR: no colors in a terminal" no_ansi
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
  run_brewshelf $'node\nlibvpx\nno-desc-dep' ''
  check "$parser: hides dependencies" contains "2 dependencies hidden"
  run_brewshelf $'node\nsdl2' ''
  check "$parser: resolves aliases" contains "1 dependency hidden"
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
