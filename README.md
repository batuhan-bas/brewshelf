# brewshelf 📚

Your Homebrew packages, organized like a library shelf.

`brew list` gives you a wall of names — most of them libraries you never asked for.
`brewshelf` shows what **you** installed, grouped into categories, each with a one-line description.

```
╔══════════════════════════════════════════════════╗
║              📚  brewshelf                       ║
╚══════════════════════════════════════════════════╝

▶ Development
──────────────────────────────────────────────────
  gh                             GitHub command-line tool
  git                            Distributed revision control system
  node                           Open-source, cross-platform JavaScript runtime environment
  pnpm                           Fast, disk space efficient package manager

▶ Database
──────────────────────────────────────────────────
  postgresql@17                  Object-relational database system
  sqlite                         Command-line interface for SQLite

▶ CLI Tools
──────────────────────────────────────────────────
  ripgrep                        Search tool like grep and The Silver Searcher
  tree                           Display directories as trees (with optional color/HTML output)

▶ Security & Network
──────────────────────────────────────────────────
  mkcert                         Simple tool to make locally trusted development certificates
  gitleaks                       Audit git repos for secrets

▶ Video & Media
──────────────────────────────────────────────────
  ffmpeg                         Play, record, convert, and stream select audio and video codecs

▶ GUI Applications (Casks)
──────────────────────────────────────────────────
  visual-studio-code             Open-source code editor
  docker-desktop                 App to build and share containerised applications and microservices

  Total: 17 packages installed
  4 dependencies hidden — run 'brewshelf --all' to show them
```

## Installation

**With Homebrew**

```bash
brew install batuhan-bas/tap/brewshelf
```

**Manually**

```bash
git clone https://github.com/batuhan-bas/brewshelf.git
install -m 755 brewshelf/brewshelf.sh "$(brew --prefix)/bin/brewshelf"
```

`$(brew --prefix)/bin` is already on your `PATH` and writable without `sudo`
(`/opt/homebrew/bin` on Apple Silicon, `/usr/local/bin` on Intel Macs).

## Usage

```bash
brewshelf        # what you installed
brewshelf --all  # plus everything installed as a dependency
```

| Option | |
|---|---|
| `-a`, `--all` | also show formulas installed as dependencies |
| `--no-color` | disable colors — also off with `NO_COLOR=1` or when the output is piped |
| `-h`, `--help` | show the help |
| `-v`, `--version` | show the version |

### What you installed vs. dependencies

Most of `brew list` is pulled in by other formulas: `ffmpeg` alone brings in dozens of codec
libraries. brewshelf hides formulas that Homebrew marks as installed only as a dependency and
counts them at the bottom — on a typical machine that turns a 160-line list into the ~35 packages
you actually chose. `--all` shows everything, with dependencies dimmed (or labelled
`(dependency)` without colors).

### Descriptions

Descriptions come from Homebrew itself (`brew info --json=v2 --installed`), so every package is
described, including the ones without a category. Formulas from
[untrusted taps](https://docs.brew.sh/Taps) are missing from that output: they are still listed,
just without a description.

## Requirements

- macOS with [Homebrew](https://brew.sh)
- zsh — the default shell since macOS Catalina

No other dependencies: the Homebrew JSON is read with `jq` when available (bundled with macOS 15
Sequoia and later) and with the JavaScript engine built into every macOS (`osascript`) otherwise.

## Categories

| Category | Color | What's in it |
|---|---|---|
| Development | Cyan | Languages, runtimes, package managers, build tools, containers |
| Database | Yellow | PostgreSQL, MySQL, Redis, MongoDB, SQLite |
| CLI Tools | Green | Terminal utilities |
| Security & Network | Red | TLS, crypto, GnuPG, DNS, HTTP clients |
| Video & Media | Magenta | FFmpeg and its codecs |
| Image & Graphics | Blue | Image formats, PDF, font rendering |
| Compression & Data | White | Compression libraries |
| System Libraries | Dim | Low-level dependencies |
| GUI Applications | Green | Homebrew casks |

Formulas without a category appear under **Other**.

## Contributing

Categories live in `brewshelf.sh` inside `init_data()`. Adding a formula is one line:

```bash
PKG_CAT[formula-name]="Category Name"
```

Run the tests before opening a PR — they use a fake `brew`, so the result doesn't depend on what's
installed on your machine:

```bash
zsh tests/run.zsh
```

## License

[MIT](LICENSE)
