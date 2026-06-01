#!/usr/bin/env zsh

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

typeset -gA PKG_CAT
typeset -gA PKG_DESC

init_data() {
  # Video & Media
  PKG_CAT[ffmpeg]="Video & Media";        PKG_DESC[ffmpeg]="Swiss-army knife for video/audio processing"
  PKG_CAT[aom]="Video & Media";           PKG_DESC[aom]="AV1 video codec library"
  PKG_CAT[dav1d]="Video & Media";         PKG_DESC[dav1d]="Fast AV1 decoder"
  PKG_CAT[rav1e]="Video & Media";         PKG_DESC[rav1e]="Fast AV1 encoder"
  PKG_CAT[svt-av1]="Video & Media";       PKG_DESC[svt-av1]="Scalable AV1 encoder by Intel"
  PKG_CAT[libvpx]="Video & Media";        PKG_DESC[libvpx]="VP8/VP9 codec"
  PKG_CAT[libvorbis]="Video & Media";     PKG_DESC[libvorbis]="Ogg Vorbis audio codec"
  PKG_CAT[libvmaf]="Video & Media";       PKG_DESC[libvmaf]="Netflix video quality metric"
  PKG_CAT[libvidstab]="Video & Media";    PKG_DESC[libvidstab]="Video stabilization library"
  PKG_CAT[x264]="Video & Media";          PKG_DESC[x264]="H.264 video encoder"
  PKG_CAT[x265]="Video & Media";          PKG_DESC[x265]="H.265/HEVC video encoder"
  PKG_CAT[xvid]="Video & Media";          PKG_DESC[xvid]="MPEG-4 video codec"
  PKG_CAT[opus]="Video & Media";          PKG_DESC[opus]="Modern audio codec"
  PKG_CAT[lame]="Video & Media";          PKG_DESC[lame]="MP3 audio encoder"
  PKG_CAT[flac]="Video & Media";          PKG_DESC[flac]="Lossless audio codec"
  PKG_CAT[theora]="Video & Media";        PKG_DESC[theora]="Ogg Theora video codec"
  PKG_CAT[speex]="Video & Media";         PKG_DESC[speex]="Speech audio codec"
  PKG_CAT[mpg123]="Video & Media";        PKG_DESC[mpg123]="MPEG audio player/decoder"
  PKG_CAT[opencore-amr]="Video & Media";  PKG_DESC[opencore-amr]="AMR audio codec (mobile standard)"
  PKG_CAT[libsamplerate]="Video & Media"; PKG_DESC[libsamplerate]="Audio sample rate converter"
  PKG_CAT[libsndfile]="Video & Media";    PKG_DESC[libsndfile]="Audio file read/write library"
  PKG_CAT[rubberband]="Video & Media";    PKG_DESC[rubberband]="Audio time-stretch and pitch-shift"
  PKG_CAT[sdl2]="Video & Media";          PKG_DESC[sdl2]="Cross-platform multimedia library"
  PKG_CAT[frei0r]="Video & Media";        PKG_DESC[frei0r]="Minimalist video plugin API"
  PKG_CAT[libbluray]="Video & Media";     PKG_DESC[libbluray]="Blu-ray disc playback library"
  PKG_CAT[libudfread]="Video & Media";    PKG_DESC[libudfread]="UDF filesystem reading (optical discs)"
  PKG_CAT[aribb24]="Video & Media";       PKG_DESC[aribb24]="ARIB STD-B24 subtitles (Japanese broadcast)"
  PKG_CAT[libass]="Video & Media";        PKG_DESC[libass]="Subtitle renderer for ASS/SSA format"
  PKG_CAT[libunibreak]="Video & Media";   PKG_DESC[libunibreak]="Unicode line/word breaking library"
  PKG_CAT[zimg]="Video & Media";          PKG_DESC[zimg]="Image scaling and colorspace library"
  PKG_CAT[librist]="Video & Media";       PKG_DESC[librist]="Reliable Internet Stream Transport"
  PKG_CAT[srt]="Video & Media";           PKG_DESC[srt]="Secure Reliable Transport streaming protocol"
  PKG_CAT[libssh]="Video & Media";        PKG_DESC[libssh]="SSH/SFTP library (used by FFmpeg)"
  PKG_CAT[libogg]="Video & Media";        PKG_DESC[libogg]="Ogg container format library"
  PKG_CAT[libsoxr]="Video & Media";       PKG_DESC[libsoxr]="High quality audio resampler"
  PKG_CAT[camsnap]="Video & Media";       PKG_DESC[camsnap]="Grab frames, clips, or motion alerts from RTSP/ONVIF cams"
  PKG_CAT[gifgrep]="Video & Media";       PKG_DESC[gifgrep]="Grep the GIF. Stick the landing"
  PKG_CAT[songsee]="Video & Media";       PKG_DESC[songsee]="Spectral visualization CLI for audio files"
  PKG_CAT[sag]="Video & Media";           PKG_DESC[sag]="Command-line ElevenLabs TTS with mac-style flags"

  # Development
  PKG_CAT[node]="Development";            PKG_DESC[node]="JavaScript runtime (Node.js)"
  PKG_CAT[nvm]="Development";             PKG_DESC[nvm]="Node.js version manager"
  PKG_CAT[pnpm]="Development";            PKG_DESC[pnpm]="Fast, disk-efficient package manager"
  PKG_CAT[python@3.12]="Development";     PKG_DESC[python@3.12]="Python 3.12"
  PKG_CAT[python@3.13]="Development";     PKG_DESC[python@3.13]="Python 3.13"
  PKG_CAT[python@3.14]="Development";     PKG_DESC[python@3.14]="Python 3.14 (latest)"
  PKG_CAT[pipx]="Development";            PKG_DESC[pipx]="Install Python CLI tools in isolated envs"
  PKG_CAT[dotnet]="Development";          PKG_DESC[dotnet]="Microsoft .NET SDK/runtime"
  PKG_CAT[gh]="Development";              PKG_DESC[gh]="GitHub official CLI"
  PKG_CAT[git]="Development";             PKG_DESC[git]="Distributed revision control system"
  PKG_CAT[go]="Development";              PKG_DESC[go]="Open source programming language"
  PKG_CAT[python@3.11]="Development";     PKG_DESC[python@3.11]="Python 3.11 interpreted programming language"
  PKG_CAT[python-tk@3.13]="Development";  PKG_DESC[python-tk@3.13]="Python interface to Tcl/Tk"
  PKG_CAT[tcl-tk]="Development";          PKG_DESC[tcl-tk]="Tool Command Language"
  PKG_CAT[xcodegen]="Development";        PKG_DESC[xcodegen]="Generate your Xcode project from a spec file"
  PKG_CAT[axe]="Development";             PKG_DESC[axe]="CLI tool for interacting with iOS Simulators via accessibility and HID APIs"
  PKG_CAT[opencode]="Development";        PKG_DESC[opencode]="AI coding agent, built for the terminal"
  PKG_CAT[codex]="Development";           PKG_DESC[codex]="OpenAI's coding agent that runs in your terminal"

  # Database
  PKG_CAT[mongodb-community]="Database";       PKG_DESC[mongodb-community]="MongoDB document database"
  PKG_CAT[mongodb-database-tools]="Database";  PKG_DESC[mongodb-database-tools]="MongoDB import/export/backup tools"
  PKG_CAT[mongodb-atlas-cli]="Database";       PKG_DESC[mongodb-atlas-cli]="MongoDB Atlas cloud management CLI"
  PKG_CAT[mongosh]="Database";                 PKG_DESC[mongosh]="Modern MongoDB shell"
  PKG_CAT[sqlite]="Database";                  PKG_DESC[sqlite]="Lightweight embedded SQL database"

  # Security & Network
  PKG_CAT[mkcert]="Security & Network";        PKG_DESC[mkcert]="Create locally-trusted SSL certificates"
  PKG_CAT[openssl@3]="Security & Network";     PKG_DESC[openssl@3]="TLS/SSL cryptography library"
  PKG_CAT[ca-certificates]="Security & Network"; PKG_DESC[ca-certificates]="Root certificate bundle"
  PKG_CAT[gnutls]="Security & Network";        PKG_DESC[gnutls]="TLS/SSL alternative to OpenSSL"
  PKG_CAT[mbedtls]="Security & Network";       PKG_DESC[mbedtls]="Lightweight TLS library"
  PKG_CAT[mbedtls@3]="Security & Network";     PKG_DESC[mbedtls@3]="Lightweight TLS library v3"
  PKG_CAT[nettle]="Security & Network";        PKG_DESC[nettle]="Low-level cryptography library"
  PKG_CAT[libsodium]="Security & Network";     PKG_DESC[libsodium]="Modern cryptography library"
  PKG_CAT[unbound]="Security & Network";       PKG_DESC[unbound]="Validating DNS resolver"
  PKG_CAT[p11-kit]="Security & Network";       PKG_DESC[p11-kit]="PKCS#11 module management"
  PKG_CAT[libtasn1]="Security & Network";      PKG_DESC[libtasn1]="ASN.1 structure parsing library"
  PKG_CAT[libidn2]="Security & Network";       PKG_DESC[libidn2]="Internationalized domain names library"
  PKG_CAT[libunistring]="Security & Network";  PKG_DESC[libunistring]="Unicode string handling library"
  PKG_CAT[c-ares]="Security & Network";        PKG_DESC[c-ares]="Async DNS resolver library"
  PKG_CAT[libevent]="Security & Network";      PKG_DESC[libevent]="Async event notification library"
  PKG_CAT[libnghttp2]="Security & Network";    PKG_DESC[libnghttp2]="HTTP/2 library"
  PKG_CAT[libnghttp3]="Security & Network";    PKG_DESC[libnghttp3]="HTTP/3 library"
  PKG_CAT[libngtcp2]="Security & Network";     PKG_DESC[libngtcp2]="QUIC transport protocol library"
  PKG_CAT[cloudflared]="Security & Network";   PKG_DESC[cloudflared]="Cloudflare Tunnel client"
  PKG_CAT[mtr]="Security & Network";           PKG_DESC[mtr]="Traceroute and ping in a single tool"
  PKG_CAT[sshpass]="Security & Network";       PKG_DESC[sshpass]="Non-interactive SSH password authentication"

  # CLI Tools
  PKG_CAT[tree]="CLI Tools";         PKG_DESC[tree]="Display directory tree in terminal"
  PKG_CAT[speedtest-cli]="CLI Tools"; PKG_DESC[speedtest-cli]="Run internet speed test from terminal"
  PKG_CAT[mailsy]="CLI Tools";       PKG_DESC[mailsy]="Generate disposable email addresses in terminal"
  PKG_CAT[zeromq]="CLI Tools";       PKG_DESC[zeromq]="High-performance async messaging library"
  PKG_CAT[bird]="CLI Tools";         PKG_DESC[bird]="Fast X CLI for tweeting, replying, and reading"
  PKG_CAT[cliclick]="CLI Tools";     PKG_DESC[cliclick]="Tool for emulating mouse and keyboard events"
  PKG_CAT[gogcli]="CLI Tools";       PKG_DESC[gogcli]="Google Suite CLI"
  PKG_CAT[goplaces]="CLI Tools";     PKG_DESC[goplaces]="Modern Go client + CLI for the Google Places API"
  PKG_CAT[himalaya]="CLI Tools";     PKG_DESC[himalaya]="CLI email client written in Rust"
  PKG_CAT[imsg]="CLI Tools";         PKG_DESC[imsg]="Send and read iMessage / SMS from the terminal"
  PKG_CAT[memo]="CLI Tools";         PKG_DESC[memo]="CLI app to manage your Apple Notes and Apple reminders"
  PKG_CAT[mole]="CLI Tools";         PKG_DESC[mole]="Deep clean and optimize your Mac"
  PKG_CAT[obsidian-cli]="CLI Tools"; PKG_DESC[obsidian-cli]="Interactive Obsidian vault manager in the terminal"
  PKG_CAT[openhue-cli]="CLI Tools";  PKG_DESC[openhue-cli]="CLI for interacting with Philips Hue smart lighting systems"
  PKG_CAT[ordercli]="CLI Tools";     PKG_DESC[ordercli]="Multi-provider order CLI (Foodora, Deliveroo)"
  PKG_CAT[peekaboo]="CLI Tools";     PKG_DESC[peekaboo]="Lightning-fast macOS screenshots & AI vision analysis"
  PKG_CAT[remindctl]="CLI Tools";    PKG_DESC[remindctl]="Fast CLI for Apple Reminders"
  PKG_CAT[ripgrep]="CLI Tools";      PKG_DESC[ripgrep]="Search tool like grep and The Silver Searcher"
  PKG_CAT[summarize]="CLI Tools";    PKG_DESC[summarize]="Multi-modal AI tool to extract and summarize content"
  PKG_CAT[wacli]="CLI Tools";        PKG_DESC[wacli]="WhatsApp CLI built on whatsmeow"

  # Image & Graphics
  PKG_CAT[cairo]="Image & Graphics";      PKG_DESC[cairo]="2D graphics rendering library"
  PKG_CAT[pango]="Image & Graphics";      PKG_DESC[pango]="Text layout and rendering"
  PKG_CAT[pixman]="Image & Graphics";     PKG_DESC[pixman]="Low-level pixel manipulation library"
  PKG_CAT[fontconfig]="Image & Graphics"; PKG_DESC[fontconfig]="Font configuration and access library"
  PKG_CAT[freetype]="Image & Graphics";   PKG_DESC[freetype]="Font rendering engine"
  PKG_CAT[harfbuzz]="Image & Graphics";   PKG_DESC[harfbuzz]="Text shaping engine"
  PKG_CAT[graphite2]="Image & Graphics";  PKG_DESC[graphite2]="Graphite smart font rendering"
  PKG_CAT[giflib]="Image & Graphics";     PKG_DESC[giflib]="GIF image format library"
  PKG_CAT[jpeg-turbo]="Image & Graphics"; PKG_DESC[jpeg-turbo]="Fast JPEG codec"
  PKG_CAT[jpeg-xl]="Image & Graphics";    PKG_DESC[jpeg-xl]="Next-gen JPEG XL image format"
  PKG_CAT[libpng]="Image & Graphics";     PKG_DESC[libpng]="PNG image format library"
  PKG_CAT[libtiff]="Image & Graphics";    PKG_DESC[libtiff]="TIFF image format library"
  PKG_CAT[webp]="Image & Graphics";       PKG_DESC[webp]="Google WebP image format"
  PKG_CAT[openjpeg]="Image & Graphics";   PKG_DESC[openjpeg]="JPEG 2000 codec"
  PKG_CAT[openjph]="Image & Graphics";    PKG_DESC[openjph]="JPEG 2000 High-Throughput codec"
  PKG_CAT[openexr]="Image & Graphics";    PKG_DESC[openexr]="HDR image format by ILM"
  PKG_CAT[imath]="Image & Graphics";      PKG_DESC[imath]="Math library for graphics (OpenEXR)"
  PKG_CAT[tesseract]="Image & Graphics";  PKG_DESC[tesseract]="OCR engine — extract text from images"
  PKG_CAT[leptonica]="Image & Graphics";  PKG_DESC[leptonica]="Image processing library (used by Tesseract)"
  PKG_CAT[highway]="Image & Graphics";    PKG_DESC[highway]="SIMD instruction abstraction library"
  PKG_CAT[little-cms2]="Image & Graphics"; PKG_DESC[little-cms2]="Color management engine"
  PKG_CAT[fribidi]="Image & Graphics";    PKG_DESC[fribidi]="Unicode bidirectional text algorithm"

  # Compression & Data
  PKG_CAT[brotli]="Compression & Data";     PKG_DESC[brotli]="Google Brotli compression"
  PKG_CAT[lz4]="Compression & Data";        PKG_DESC[lz4]="Extremely fast compression"
  PKG_CAT[lzo]="Compression & Data";        PKG_DESC[lzo]="Fast data compression library"
  PKG_CAT[xz]="Compression & Data";         PKG_DESC[xz]="XZ/LZMA compression"
  PKG_CAT[zstd]="Compression & Data";       PKG_DESC[zstd]="Facebook Zstandard compression"
  PKG_CAT[snappy]="Compression & Data";     PKG_DESC[snappy]="Fast compression by Google"
  PKG_CAT[libarchive]="Compression & Data"; PKG_DESC[libarchive]="Multi-format archive library"
  PKG_CAT[libdeflate]="Compression & Data"; PKG_DESC[libdeflate]="Fast DEFLATE/zlib compression"
  PKG_CAT[libb2]="Compression & Data";      PKG_DESC[libb2]="BLAKE2 cryptographic hash library"

  # System Libraries
  PKG_CAT[glib]="System Libraries";      PKG_DESC[glib]="Core utility library for GNOME/GTK"
  PKG_CAT[gmp]="System Libraries";       PKG_DESC[gmp]="GNU multiple precision arithmetic"
  PKG_CAT[gettext]="System Libraries";   PKG_DESC[gettext]="Internationalization (i18n) utilities"
  PKG_CAT[icu4c@76]="System Libraries";  PKG_DESC[icu4c@76]="Unicode/globalization support (v76)"
  PKG_CAT[icu4c@77]="System Libraries";  PKG_DESC[icu4c@77]="Unicode/globalization support (v77)"
  PKG_CAT[icu4c@78]="System Libraries";  PKG_DESC[icu4c@78]="Unicode/globalization support (v78)"
  PKG_CAT[pcre2]="System Libraries";     PKG_DESC[pcre2]="Perl-compatible regular expressions v2"
  PKG_CAT[readline]="System Libraries";  PKG_DESC[readline]="Line editing in terminal (used by shells)"
  PKG_CAT[mpdecimal]="System Libraries"; PKG_DESC[mpdecimal]="Decimal arithmetic library (Python uses this)"
  PKG_CAT[libuv]="System Libraries";     PKG_DESC[libuv]="Async I/O library (Node.js uses this)"
  PKG_CAT[uvwasi]="System Libraries";    PKG_DESC[uvwasi]="WASI system call implementation"
  PKG_CAT[simdjson]="System Libraries";  PKG_DESC[simdjson]="Fastest JSON parser (SIMD-accelerated)"
  PKG_CAT[cjson]="System Libraries";     PKG_DESC[cjson]="Ultralightweight JSON parser in C"
  PKG_CAT[libxcb]="System Libraries";    PKG_DESC[libxcb]="X11 C bindings"
  PKG_CAT[libx11]="System Libraries";    PKG_DESC[libx11]="Core X11 library"
  PKG_CAT[libxext]="System Libraries";   PKG_DESC[libxext]="X11 extensions library"
  PKG_CAT[libxrender]="System Libraries"; PKG_DESC[libxrender]="X11 rendering extension"
  PKG_CAT[libxau]="System Libraries";    PKG_DESC[libxau]="X11 authorization library"
  PKG_CAT[libxdmcp]="System Libraries";  PKG_DESC[libxdmcp]="X11 display manager control protocol"
  PKG_CAT[xorgproto]="System Libraries"; PKG_DESC[xorgproto]="X.Org protocol headers"
  PKG_CAT[libmicrohttpd]="System Libraries"; PKG_DESC[libmicrohttpd]="Embeddable HTTP server library"
  PKG_CAT[jansson]="System Libraries";   PKG_DESC[jansson]="C library for encoding, decoding, and manipulating JSON"
  PKG_CAT[libiconv]="System Libraries";  PKG_DESC[libiconv]="Character set conversion library"
  PKG_CAT[libtommath]="System Libraries"; PKG_DESC[libtommath]="C library for number theoretic multiple-precision integers"
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
  formulas=("${(@f)$(brew list --formula 2>/dev/null)}")
  casks=("${(@f)$(brew list --cask 2>/dev/null)}")

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
  local color desc
  order=("Development" "Database" "CLI Tools" "Security & Network" "Video & Media" "Image & Graphics" "Compression & Data" "System Libraries")

  for cat in "${order[@]}"; do
    [[ -z "${cat_items[$cat]:-}" ]] && continue
    case "$cat" in
      "Video & Media")      color="$MAGENTA" ;;
      "Development")        color="$CYAN" ;;
      "Database")           color="$YELLOW" ;;
      "Security & Network") color="$RED" ;;
      "CLI Tools")          color="$GREEN" ;;
      "Image & Graphics")   color="$BLUE" ;;
      "Compression & Data") color="$WHITE" ;;
      "System Libraries")   color="$DIM" ;;
      *)                    color="$WHITE" ;;
    esac
    print "${BOLD}${color}▶ ${cat}${RESET}"
    print "${color}$(printf '─%.0s' {1..50})${RESET}"
    for pkg in ${=cat_items[$cat]}; do
      desc="${PKG_DESC[$pkg]:-No description available}"
      printf "  ${BOLD}%-30s${RESET} ${DIM}%s${RESET}\n" "$pkg" "$desc"
    done
    echo ""
  done

  if [[ ${#unknown[@]} -gt 0 ]]; then
    print "${BOLD}${DIM}▶ Other / Dependencies${RESET}"
    print "${DIM}$(printf '─%.0s' {1..50})${RESET}"
    for pkg in "${unknown[@]}"; do
      printf "  ${DIM}%s${RESET}\n" "$pkg"
    done
    echo ""
  fi

  if [[ ${#casks[@]} -gt 0 ]]; then
    typeset -A cask_desc
    cask_desc[claude-code]="Anthropic's Claude CLI for coding"
    cask_desc[android-platform-tools]="ADB and fastboot for Android debugging"
    cask_desc[mongodb-compass]="Visual GUI for MongoDB"
    cask_desc[git-credential-manager]="Secure Git credential storage"
    cask_desc[codex]="OpenAI's coding agent that runs in your terminal"
    cask_desc[codexbar]="Menu bar usage monitor for Codex and Claude"
    cask_desc[gcloud-cli]="Google Cloud CLI to manage resources and applications"
    cask_desc[ngrok]="Reverse proxy, secure tunnels to localhost"
    cask_desc[openinterminal]="Finder Toolbar app to open current directory in Terminal or Editor"
    cask_desc[tigervnc]="Multi-platform VNC client and server"
    cask_desc[tigervnc-viewer]="Multi-platform VNC client"

    print "${BOLD}${GREEN}▶ GUI Applications (Casks)${RESET}"
    print "${GREEN}$(printf '─%.0s' {1..50})${RESET}"
    for cask in "${casks[@]}"; do
      local cdesc="${cask_desc[$cask]:-GUI application}"
      printf "  ${BOLD}%-30s${RESET} ${DIM}%s${RESET}\n" "$cask" "$cdesc"
    done
    echo ""
  fi

  local total=$(( ${#formulas[@]} + ${#casks[@]} ))
  print "${DIM}  Total: ${total} packages installed${RESET}"
  echo ""
}

init_data
print_shelf
