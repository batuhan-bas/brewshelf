# brewshelf 📚

Your Homebrew packages, organized like a shelf.

`brew list` gives you a wall of names. `brewshelf` gives you a categorized, color-coded library — every package with a plain-English description of what it actually does.

## Preview

```
╔══════════════════════════════════════════════════╗
║              📚  brewshelf                       ║
╚══════════════════════════════════════════════════╝

▶ Development
──────────────────────────────────────────────────
  node                           JavaScript runtime (Node.js)
  nvm                            Node.js version manager
  pnpm                           Fast, disk-efficient package manager
  python@3.14                    Python 3.14 (latest)
  gh                             GitHub official CLI

▶ Database
──────────────────────────────────────────────────
  mongodb-community              MongoDB document database
  mongosh                        Modern MongoDB shell
  sqlite                         Lightweight embedded SQL database

▶ Video & Media
──────────────────────────────────────────────────
  ffmpeg                         Swiss-army knife for video/audio processing
  ...
```

## Installation

**1. Clone the repo**

```bash
git clone https://github.com/YOUR_USERNAME/brewshelf.git
cd brewshelf
```

**2. Install globally**

```bash
sudo cp brewshelf.sh /usr/local/bin/brewshelf
sudo chmod +x /usr/local/bin/brewshelf
```

**3. Run**

```bash
brewshelf        # what you installed
brewshelf --all  # plus everything installed as a dependency
```

By default brewshelf shows only what you installed yourself: formulas installed as a dependency
of another formula (codecs, libraries, …) are hidden and counted at the bottom. On a typical
machine that turns a 160-line list into the ~35 packages you actually chose.

## Requirements

- macOS (tested on macOS Sequoia)
- zsh (default shell since macOS Catalina)
- Homebrew

## Categories

| Category | Color | What's in it |
|---|---|---|
| Development | Cyan | Node, Python, package managers, GitHub CLI |
| Database | Yellow | MongoDB, SQLite |
| CLI Tools | Green | Terminal utilities |
| Security & Network | Red | TLS, crypto, DNS libraries |
| Video & Media | Magenta | FFmpeg and its codec dependencies |
| Image & Graphics | Blue | Image formats, font rendering |
| Compression & Data | White | Compression libraries |
| System Libraries | Dim | Low-level dependencies |
| GUI Applications | Green | Homebrew casks |

Packages without a category appear under **Other**.

## Descriptions

Every description comes from Homebrew itself (`brew info --json=v2 --installed`), so all packages
are described — including the ones brewshelf has no category for. Packages from
[untrusted taps](https://docs.brew.sh/Taps) are still listed, just without a description.

## Adding categories

Categories live in `brewshelf.sh` inside the `init_data()` function. Adding a package is one line:

```bash
PKG_CAT[package-name]="Category Name"
```

PRs for uncategorized packages are welcome.

## License

MIT
