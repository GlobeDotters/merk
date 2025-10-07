# MERK Flatpak Packaging (branch: packaging/flatpak)

_Last updated: 2025-02-14_

This branch tracks the work needed to ship MERK as a Flatpak and eventually
submit it to Flathub.  The upstream project is still PyQt5/Qt5-based, so the
manifest targets the KDE Runtime 5.15-23.08 (Python 3.11).

## What changed compared to upstream

- **Flatpak manifest & metadata** were rebuilt around the new ID
  `io.github.NutjobLaboratories.Merk` with refreshed desktop file, icons (16 →
  512 px), and AppStream entry.
- **Python compatibility fixes** swap a handful of double-quoted f-strings to
  use single quotes so they parse under Python 3.11.
- **Sound fallback** (`merk/_qsound.py`) installs a tiny wrapper around
  `QSound`.  When the runtime lacks `libgssapi_krb5.so.2`, MERK keeps running but
  silently skips audio notifications instead of crashing.
- **Launcher adjustments** stage the full tree in
  `/app/share/io.github.NutjobLaboratories.Merk` and execute `merk.py` directly
  (avoids Qt5reactor import issues when `python -m` is used).
- **Packaging docs** (`requirements.in`, this README) describe how to refresh
  dependency hashes and build the Flatpak.

None of the behavioural tweaks touch runtime logic—everything is either parser
compatibility or robustness around optional dependencies.

## Building & testing locally

1. Install the required runtimes once:
   ```bash
   flatpak install flathub org.kde.Sdk//5.15-23.08 org.kde.Platform//5.15-23.08
   ```
2. From the repository root, build and install the sandboxed app:
   ```bash
   flatpak-builder --user --install --force-clean \
     build-dir packaging-flatpak/io.github.NutjobLaboratories.Merk.yml
   ```
3. Launch the Flatpak build for manual testing:
   ```bash
   flatpak run io.github.NutjobLaboratories.Merk
   ```

The manifest enables Wayland + X11, PulseAudio, and access to `$XDG_DESKTOP` and
`$XDG_DOWNLOAD_DIR`.  Audio cues are muted if Kerberos libraries are absent.

## Updating dependencies

Runtime Python packages are pinned via `requirements.in` → `requirements.txt`.
Regenerate the lockfile with the KDE SDK’s Python 3.11 so hashes match the
runtime:

```bash
flatpak run --command=bash org.kde.Sdk//5.15-23.08 <<'EOS'
pip3 install --user pip-tools
cd /var/home/$USER/Projects/python/merk
pip-compile --generate-hashes \
  --output-file=packaging-flatpak/requirements.txt \
  packaging-flatpak/requirements.in
EOS
```

Commit the updated `requirements.txt` and rerun `flatpak-builder` to make sure
all wheels install inside the sandbox.

## Preparing a Flathub submission

- Replace the `merk` module source with a tarball/commit from a tagged release
  rather than the in-tree checkout.
- Update the AppStream `<release>` block and `<update_contact>` with real data
  before publishing.
- If you want audio notifications inside the Flatpak, bundle MIT Kerberos via
  the [`shared-modules`](https://github.com/flathub/shared-modules) `kerberos`
  recipe; otherwise the no-op shim is acceptable but should be mentioned in the
  Flathub PR.
- Run `appstreamcli validate packaging-flatpak/io.github.NutjobLaboratories.Merk.metainfo.xml`
  outside the sandbox so URL checks succeed.
- Capture test output (`flatpak run …`) or screenshots for review.

## Known limitations

- **Sound output**: silent unless Kerberos libs are bundled.
- **Runtime**: still Qt5; moving to Qt6/PyQt6 would let us use the KDE 6.x
  runtime (Python ≥3.12) but requires an upstream port.
- **Screenshots**: URLs point to the `main` branch; adjust if you publish from a
  different fork or tag.

## Quick changelog (2025-02-14)

- Rename app ID, desktop file, and icon stack to
  `io.github.NutjobLaboratories.Merk`.
- Added Flatpak-specific README, manifest tweaks (filesystem/pulse permissions,
  locale cleanup removal).
- Added `requirements.in` and hardened hash workflow.
- Introduced `_qsound` fallback and Python 3.11-safe string formatting.

Keep this document up to date as the packaging evolves or when pushing release
candidates toward Flathub.
