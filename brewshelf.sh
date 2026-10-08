#!/usr/bin/env zsh

# Must stay POSIX-compatible up to this check: `bash brewshelf.sh` or `sh brewshelf.sh`
# would otherwise fail later with a cryptic zsh syntax error
if [ -z "$ZSH_VERSION" ]; then
  echo "brewshelf: this script requires zsh — run it as 'zsh brewshelf.sh' or './brewshelf.sh'" >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  print -u2 "brewshelf: Homebrew not found — install it from https://brew.sh"
  exit 1
fi

# Colors
BOLD=$'\e[1m'
RESET=$'\e[0m'
DIM=$'\e[2m'
CYAN=$'\e[36m'
YELLOW=$'\e[33m'
GREEN=$'\e[32m'
MAGENTA=$'\e[35m'
BLUE=$'\e[34m'
RED=$'\e[31m'
WHITE=$'\e[37m'

# Category of each known formula. Descriptions come from Homebrew itself (load_descriptions).
typeset -gA PKG_CAT
typeset -gA FORMULA_DESC CASK_DESC

# Reads the descriptions of all installed packages from `brew info --json=v2 --installed`
# and prints them as "formula|cask <TAB> name <TAB> description" lines.
# Uses jq when available (bundled with macOS 15+), otherwise JavaScript via osascript,
# which every macOS has. BREWSHELF_JSON_PARSER=jq|osascript forces one (used by the tests).
json_to_rows() {
  local parser=${BREWSHELF_JSON_PARSER:-}
  if [[ -z "$parser" ]]; then
    if command -v jq >/dev/null 2>&1; then parser=jq; else parser=osascript; fi
  fi

  if [[ "$parser" == jq ]]; then
    jq -r '
      def clean: (. // "") | gsub("[\t\n\r]+"; " ");
      (.formulae[]? | ["formula", .name, (.desc | clean)]),
      (.casks[]?    | ["cask", .token, (.desc | clean)])
      | join("\t")'
  else
    osascript -l JavaScript -e '
      ObjC.import("Foundation");
      const data = $.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile;
      const info = JSON.parse($.NSString.alloc.initWithDataEncoding(data, $.NSUTF8StringEncoding).js);
      const clean = (s) => (s || "").replace(/[\t\n\r]+/g, " ");
      [
        ...(info.formulae || []).map((f) => ["formula", f.name, clean(f.desc)].join("\t")),
        ...(info.casks || []).map((c) => ["cask", c.token, clean(c.desc)].join("\t")),
      ].join("\n");'
  fi
}

# Packages from untrusted taps or removed from Homebrew are missing from the JSON;
# they are still listed (from `brew list`), just without a description.
load_descriptions() {
  local row kind name desc
  for row in ${(f)"$(brew info --json=v2 --installed 2>/dev/null | json_to_rows 2>/dev/null)"}; do
    IFS=$'\t' read -r kind name desc <<< "$row"
    case "$kind" in
      formula) FORMULA_DESC[$name]=$desc ;;
      cask)    CASK_DESC[$name]=$desc ;;
    esac
  done
}

init_data() {
  # Video & Media
  PKG_CAT[ffmpeg]="Video & Media"
  PKG_CAT[aom]="Video & Media"
  PKG_CAT[dav1d]="Video & Media"
  PKG_CAT[rav1e]="Video & Media"
  PKG_CAT[svt-av1]="Video & Media"
  PKG_CAT[libvpx]="Video & Media"
  PKG_CAT[libvorbis]="Video & Media"
  PKG_CAT[libvmaf]="Video & Media"
  PKG_CAT[libvidstab]="Video & Media"
  PKG_CAT[x264]="Video & Media"
  PKG_CAT[x265]="Video & Media"
  PKG_CAT[xvid]="Video & Media"
  PKG_CAT[opus]="Video & Media"
  PKG_CAT[lame]="Video & Media"
  PKG_CAT[flac]="Video & Media"
  PKG_CAT[theora]="Video & Media"
  PKG_CAT[speex]="Video & Media"
  PKG_CAT[mpg123]="Video & Media"
  PKG_CAT[opencore-amr]="Video & Media"
  PKG_CAT[libsamplerate]="Video & Media"
  PKG_CAT[libsndfile]="Video & Media"
  PKG_CAT[rubberband]="Video & Media"
  PKG_CAT[sdl2]="Video & Media"
  PKG_CAT[frei0r]="Video & Media"
  PKG_CAT[libbluray]="Video & Media"
  PKG_CAT[libudfread]="Video & Media"
  PKG_CAT[aribb24]="Video & Media"
  PKG_CAT[libass]="Video & Media"
  PKG_CAT[libunibreak]="Video & Media"
  PKG_CAT[zimg]="Video & Media"
  PKG_CAT[librist]="Video & Media"
  PKG_CAT[srt]="Video & Media"
  PKG_CAT[libssh]="Video & Media"
  PKG_CAT[libogg]="Video & Media"
  PKG_CAT[libsoxr]="Video & Media"
  PKG_CAT[camsnap]="Video & Media"
  PKG_CAT[gifgrep]="Video & Media"
  PKG_CAT[songsee]="Video & Media"
  PKG_CAT[sag]="Video & Media"

  # Development
  PKG_CAT[node]="Development"
  PKG_CAT[nvm]="Development"
  PKG_CAT[pnpm]="Development"
  PKG_CAT[python@3.12]="Development"
  PKG_CAT[python@3.13]="Development"
  PKG_CAT[python@3.14]="Development"
  PKG_CAT[pipx]="Development"
  PKG_CAT[dotnet]="Development"
  PKG_CAT[gh]="Development"
  PKG_CAT[git]="Development"
  PKG_CAT[go]="Development"
  PKG_CAT[python@3.11]="Development"
  PKG_CAT[python-tk@3.13]="Development"
  PKG_CAT[tcl-tk]="Development"
  PKG_CAT[xcodegen]="Development"
  PKG_CAT[axe]="Development"
  PKG_CAT[opencode]="Development"
  PKG_CAT[codex]="Development"

  # Database
  PKG_CAT[mongodb-community]="Database"
  PKG_CAT[mongodb-database-tools]="Database"
  PKG_CAT[mongodb-atlas-cli]="Database"
  PKG_CAT[mongosh]="Database"
  PKG_CAT[sqlite]="Database"

  # Security & Network
  PKG_CAT[mkcert]="Security & Network"
  PKG_CAT[openssl@3]="Security & Network"
  PKG_CAT[ca-certificates]="Security & Network"
  PKG_CAT[gnutls]="Security & Network"
  PKG_CAT[mbedtls]="Security & Network"
  PKG_CAT[mbedtls@3]="Security & Network"
  PKG_CAT[nettle]="Security & Network"
  PKG_CAT[libsodium]="Security & Network"
  PKG_CAT[unbound]="Security & Network"
  PKG_CAT[p11-kit]="Security & Network"
  PKG_CAT[libtasn1]="Security & Network"
  PKG_CAT[libidn2]="Security & Network"
  PKG_CAT[libunistring]="Security & Network"
  PKG_CAT[c-ares]="Security & Network"
  PKG_CAT[libevent]="Security & Network"
  PKG_CAT[libnghttp2]="Security & Network"
  PKG_CAT[libnghttp3]="Security & Network"
  PKG_CAT[libngtcp2]="Security & Network"
  PKG_CAT[cloudflared]="Security & Network"
  PKG_CAT[mtr]="Security & Network"
  PKG_CAT[sshpass]="Security & Network"

  # CLI Tools
  PKG_CAT[tree]="CLI Tools"
  PKG_CAT[speedtest-cli]="CLI Tools"
  PKG_CAT[mailsy]="CLI Tools"
  PKG_CAT[zeromq]="CLI Tools"
  PKG_CAT[bird]="CLI Tools"
  PKG_CAT[cliclick]="CLI Tools"
  PKG_CAT[gogcli]="CLI Tools"
  PKG_CAT[goplaces]="CLI Tools"
  PKG_CAT[himalaya]="CLI Tools"
  PKG_CAT[imsg]="CLI Tools"
  PKG_CAT[memo]="CLI Tools"
  PKG_CAT[mole]="CLI Tools"
  PKG_CAT[obsidian-cli]="CLI Tools"
  PKG_CAT[openhue-cli]="CLI Tools"
  PKG_CAT[ordercli]="CLI Tools"
  PKG_CAT[peekaboo]="CLI Tools"
  PKG_CAT[remindctl]="CLI Tools"
  PKG_CAT[ripgrep]="CLI Tools"
  PKG_CAT[summarize]="CLI Tools"
  PKG_CAT[wacli]="CLI Tools"

  # Image & Graphics
  PKG_CAT[cairo]="Image & Graphics"
  PKG_CAT[pango]="Image & Graphics"
  PKG_CAT[pixman]="Image & Graphics"
  PKG_CAT[fontconfig]="Image & Graphics"
  PKG_CAT[freetype]="Image & Graphics"
  PKG_CAT[harfbuzz]="Image & Graphics"
  PKG_CAT[graphite2]="Image & Graphics"
  PKG_CAT[giflib]="Image & Graphics"
  PKG_CAT[jpeg-turbo]="Image & Graphics"
  PKG_CAT[jpeg-xl]="Image & Graphics"
  PKG_CAT[libpng]="Image & Graphics"
  PKG_CAT[libtiff]="Image & Graphics"
  PKG_CAT[webp]="Image & Graphics"
  PKG_CAT[openjpeg]="Image & Graphics"
  PKG_CAT[openjph]="Image & Graphics"
  PKG_CAT[openexr]="Image & Graphics"
  PKG_CAT[imath]="Image & Graphics"
  PKG_CAT[tesseract]="Image & Graphics"
  PKG_CAT[leptonica]="Image & Graphics"
  PKG_CAT[highway]="Image & Graphics"
  PKG_CAT[little-cms2]="Image & Graphics"
  PKG_CAT[fribidi]="Image & Graphics"

  # Compression & Data
  PKG_CAT[brotli]="Compression & Data"
  PKG_CAT[lz4]="Compression & Data"
  PKG_CAT[lzo]="Compression & Data"
  PKG_CAT[xz]="Compression & Data"
  PKG_CAT[zstd]="Compression & Data"
  PKG_CAT[snappy]="Compression & Data"
  PKG_CAT[libarchive]="Compression & Data"
  PKG_CAT[libdeflate]="Compression & Data"
  PKG_CAT[libb2]="Compression & Data"

  # System Libraries
  PKG_CAT[glib]="System Libraries"
  PKG_CAT[gmp]="System Libraries"
  PKG_CAT[gettext]="System Libraries"
  PKG_CAT[icu4c@76]="System Libraries"
  PKG_CAT[icu4c@77]="System Libraries"
  PKG_CAT[icu4c@78]="System Libraries"
  PKG_CAT[pcre2]="System Libraries"
  PKG_CAT[readline]="System Libraries"
  PKG_CAT[mpdecimal]="System Libraries"
  PKG_CAT[libuv]="System Libraries"
  PKG_CAT[uvwasi]="System Libraries"
  PKG_CAT[simdjson]="System Libraries"
  PKG_CAT[cjson]="System Libraries"
  PKG_CAT[libxcb]="System Libraries"
  PKG_CAT[libx11]="System Libraries"
  PKG_CAT[libxext]="System Libraries"
  PKG_CAT[libxrender]="System Libraries"
  PKG_CAT[libxau]="System Libraries"
  PKG_CAT[libxdmcp]="System Libraries"
  PKG_CAT[xorgproto]="System Libraries"
  PKG_CAT[libmicrohttpd]="System Libraries"
  PKG_CAT[jansson]="System Libraries"
  PKG_CAT[libiconv]="System Libraries"
  PKG_CAT[libtommath]="System Libraries"
}

category_color() {
  case "$1" in
    "Video & Media")      echo -n "$MAGENTA" ;;
    "Development")        echo -n "$CYAN" ;;
    "Database")           echo -n "$YELLOW" ;;
    "Security & Network") echo -n "$RED" ;;
    "CLI Tools")          echo -n "$GREEN" ;;
    "Image & Graphics")   echo -n "$BLUE" ;;
    "Compression & Data") echo -n "$WHITE" ;;
    "System Libraries")   echo -n "$DIM" ;;
    *)                    echo -n "$WHITE" ;;
  esac
}

print_shelf() {
  local -a formulas casks
  # ${(f)...} unquoted drops empty lines, so an empty list becomes an empty array
  # (the quoted "${(@f)...}" form yields one empty element instead)
  formulas=(${(f)"$(brew list --formula 2>/dev/null)"})
  casks=(${(f)"$(brew list --cask 2>/dev/null)"})

  if (( ${#formulas[@]} == 0 && ${#casks[@]} == 0 )); then
    print "No Homebrew packages installed."
    return 0
  fi

  typeset -A cat_items
  local -a unknown

  for pkg in "${formulas[@]}"; do
    local cat="${PKG_CAT[$pkg]:-}"
    if [[ -n "$cat" ]]; then
      cat_items[$cat]+="$pkg "
    else
      unknown+=("$pkg")
    fi
  done

  echo ""
  print "${BOLD}╔══════════════════════════════════════════════════╗${RESET}"
  print "${BOLD}║              📚  brewshelf                       ║${RESET}"
  print "${BOLD}╚══════════════════════════════════════════════════╝${RESET}"
  echo ""

  local -a order
  local color
  order=("Development" "Database" "CLI Tools" "Security & Network" "Video & Media" "Image & Graphics" "Compression & Data" "System Libraries")

  for cat in "${order[@]}"; do
    [[ -z "${cat_items[$cat]:-}" ]] && continue
    color="$(category_color "$cat")"
    print "${BOLD}${color}▶ ${cat}${RESET}"
    print "${color}$(printf '─%.0s' {1..50})${RESET}"
    for pkg in ${=cat_items[$cat]}; do
      printf "  ${BOLD}%-30s${RESET} ${DIM}%s${RESET}\n" "$pkg" "${FORMULA_DESC[$pkg]:-}"
    done
    echo ""
  done

  if [[ ${#unknown[@]} -gt 0 ]]; then
    print "${BOLD}${DIM}▶ Other / Dependencies${RESET}"
    print "${DIM}$(printf '─%.0s' {1..50})${RESET}"
    for pkg in "${unknown[@]}"; do
      printf "  ${DIM}%-30s %s${RESET}\n" "$pkg" "${FORMULA_DESC[$pkg]:-}"
    done
    echo ""
  fi

  if [[ ${#casks[@]} -gt 0 ]]; then
    print "${BOLD}${GREEN}▶ GUI Applications (Casks)${RESET}"
    print "${GREEN}$(printf '─%.0s' {1..50})${RESET}"
    for cask in "${casks[@]}"; do
      printf "  ${BOLD}%-30s${RESET} ${DIM}%s${RESET}\n" "$cask" "${CASK_DESC[$cask]:-}"
    done
    echo ""
  fi

  local total=$(( ${#formulas[@]} + ${#casks[@]} ))
  local noun="packages"
  (( total == 1 )) && noun="package"
  print "${DIM}  Total: ${total} ${noun} installed${RESET}"
  echo ""
}

init_data
load_descriptions
print_shelf
