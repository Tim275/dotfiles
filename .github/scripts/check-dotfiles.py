#!/usr/bin/env python3
"""Prueft die Fehlerklassen, die den Bootstrap auf frischen Maschinen zerlegt haben."""
import json
import os
import re
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BREWFILE = (ROOT / "dot_Brewfile").read_text()
fails = []


def fail(check, msg):
    fails.append(f"{check}: {msg}")


def in_brewfile(name):
    return re.search(rf'^(brew|cask) "{re.escape(name)}"', BREWFILE, re.M) is not None


# Jede verwaltete App-Config braucht ihr installierendes Paket.
# Neue Config ohne Eintrag hier = bewusster Fehlschlag, nicht stiller Durchrutscher.
CONFIG_PACKAGE = {
    "aerospace": "nikitabobko/tap/aerospace",
    "atuin": "atuin",
    "fastfetch": "fastfetch",
    "ghostty": "ghostty",
    "karabiner": "karabiner-elements",
    "mise": "mise",
    "nvim": "neovim",
    "sketchybar": "felixkratz/formulae/sketchybar",
    "starship": "starship",
    "tmux": "tmux",
}


def check_config_has_package():
    for d in sorted((ROOT / "dot_config").iterdir()):
        if not d.is_dir():
            continue
        pkg = CONFIG_PACKAGE.get(d.name)
        if pkg is None:
            fail("config-ohne-paket", f"{d.name} ist neu — Paket in CONFIG_PACKAGE eintragen")
        elif not in_brewfile(pkg):
            fail("config-ohne-paket", f"{d.name} braucht '{pkg}', fehlt im Brewfile")
    if (ROOT / "dot_warp").is_dir() and not in_brewfile("warp"):
        fail("config-ohne-paket", "dot_warp braucht cask \"warp\"")


def source_file_exists(target_rel):
    """Findet die Quelldatei zu einem Zielpfad, inkl. chezmoi-Attribut-Praefixen."""
    parts = target_rel.split("/")
    parts[0] = "dot_" + parts[0].lstrip(".")
    parent = ROOT / "/".join(parts[:-1])
    base = parts[-1]
    if not parent.is_dir():
        return False
    return any(f.name.lstrip("").endswith(base) and
               re.fullmatch(r"(executable_|private_|readonly_|symlink_)*" + re.escape(base), f.name)
               for f in parent.iterdir())


def check_referenced_files():
    pat = re.compile(r"(?:~|\$HOME)/(\.[\w./-]+)")
    for cfg in list((ROOT / "dot_config").rglob("*")) + [ROOT / "dot_zshrc"]:
        if not cfg.is_file() or cfg.suffix in {".gif", ".png", ".webp", ".json"}:
            continue
        try:
            text = cfg.read_text()
        except UnicodeDecodeError:
            continue
        for ref in set(pat.findall(text)):
            # Laufzeit-Artefakte: vom jeweiligen Tool erzeugt, gehoeren nicht ins Repo
            if any(s in ref for s in ("plugins/", "/plugins", ".local/share", ".cache",
                                      ".zcompdump", "lean-ctx/")):
                continue
            if not ref.startswith((".config/", ".local/bin/")):
                continue
            if not source_file_exists(ref):
                fail("referenz-fehlt", f"{cfg.relative_to(ROOT)} verweist auf ~/{ref} — nicht im Repo")


def check_no_hardcoded_home():
    pat = re.compile(r"/Users/[a-z][a-z0-9._-]*", re.I)
    for f in ROOT.rglob("*"):
        if not f.is_file() or ".git/" in str(f) or f.suffix in {".gif", ".png", ".webp"}:
            continue
        try:
            text = f.read_text()
        except (UnicodeDecodeError, PermissionError):
            continue
        for m in set(pat.findall(text)):
            fail("harter-pfad", f"{f.relative_to(ROOT)} enthaelt '{m}' — $HOME benutzen")


def check_no_silent_failures():
    for f in (ROOT / ".chezmoiscripts").iterdir():
        for n, line in enumerate(f.read_text().splitlines(), 1):
            if "|| true" in line:
                fail("stiller-fehler", f"{f.name}:{n} — '|| true' verschluckt Fehler")


def check_no_secrets():
    pats = {
        "GitHub-Token": r"gh[pousr]_[A-Za-z0-9]{20,}",
        "GitHub-PAT": r"github_pat_[A-Za-z0-9]{20,}",
        "Private-Key": r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
        "AWS-Key": r"AKIA[0-9A-Z]{16}",
        "Slack-Token": r"xox[baprs]-[0-9A-Za-z-]{10,}",
        "GitLab-Token": r"glpat-[A-Za-z0-9_-]{15,}",
    }
    for f in ROOT.rglob("*"):
        if not f.is_file() or ".git/" in str(f) or f.suffix in {".gif", ".png", ".webp"}:
            continue
        try:
            text = f.read_text()
        except (UnicodeDecodeError, PermissionError):
            continue
        for n, line in enumerate(text.splitlines(), 1):
            if "pattern =" in line or "pattern:" in line:
                continue  # Warps Redaction-Regexe sind Definitionen, keine Secrets
            for name, p in pats.items():
                if re.search(p, line):
                    fail("secret", f"{f.relative_to(ROOT)}:{n} — moeglicher {name}")


def check_brewfile_alive():
    entries = [("formula", m) for m in re.findall(r'^brew "([^"]+)"', BREWFILE, re.M)]
    entries += [("cask", m) for m in re.findall(r'^cask "([^"]+)"', BREWFILE, re.M)]

    def alive(item):
        kind, name = item
        if "/" in name:
            return None  # Tap-Pakete liegen nicht in der core-API, nur brew selbst kennt sie
        url = f"https://formulae.brew.sh/api/{kind}/{name}.json"
        try:
            with urllib.request.urlopen(url, timeout=30) as r:
                return None if r.status == 200 else (kind, name, r.status)
        except urllib.error.HTTPError as e:
            return (kind, name, e.code)
        except Exception as e:
            return (kind, name, str(e))

    with ThreadPoolExecutor(max_workers=12) as ex:
        for res in ex.map(alive, entries):
            if res:
                fail("totes-paket", f"{res[0]} '{res[1]}' -> HTTP {res[2]}")


CHECKS = [
    ("Config hat installierendes Paket", check_config_has_package),
    ("Referenzierte Dateien im Repo", check_referenced_files),
    ("Keine harten /Users-Pfade", check_no_hardcoded_home),
    ("Keine stillen Fehler in Skripten", check_no_silent_failures),
    ("Keine Secrets", check_no_secrets),
]
if os.environ.get("SKIP_NETWORK") != "1":
    CHECKS.append(("Brewfile-Pakete existieren upstream", check_brewfile_alive))

for label, fn in CHECKS:
    before = len(fails)
    fn()
    print(f"{'FAIL' if len(fails) > before else 'ok  '}  {label}")

if fails:
    print("\n" + "\n".join(f"  - {f}" for f in fails))
    sys.exit(1)
print("\nalles sauber")
