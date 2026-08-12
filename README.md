# ImmortalWrt 24.10.5 x86-64 EFI

This project builds a reproducible, lightly customized ImmortalWrt x86-64 EFI image from the official 24.10.5 ImageBuilder. It uses the release's package repositories and creates Bandix IPKs from pinned upstream revisions, because Bandix is not published in the official feed.

## GitHub Actions build

Use **Actions → Build ImmortalWrt firmware → Run workflow** in the GitHub repository. The workflow downloads the official x86_64 ImageBuilder, builds in an Ubuntu `linux/amd64` Docker container, and uploads the EFI image, QCOW2 conversion, and package manifest as a 14-day workflow artifact.

No local Docker, QEMU, ImageBuilder cache, or test disk is required. The workflow is manually triggered so ordinary documentation changes do not consume build minutes.

The repository intentionally stores build inputs only: the workflow, ImageBuilder wrapper, container recipe, package and feed selections, and firmware overlay. Firmware images are GitHub Actions artifacts and are never committed.

## Local checks

Run `make check` before pushing changes. It checks shell syntax, verifies no removed build paths are referenced, and checks the Git diff for whitespace errors. `make build` is available only to reproduce the ImageBuilder workflow locally; it requires Docker, `curl`, `gzip`, `python3`, `qemu-img`, `shasum`, `tar`, and an extracted official 24.10.5 x86_64 ImageBuilder at `imagebuilder/immortalwrt-imagebuilder-24.10.5-x86-64.Linux-x86_64`.

The firmware includes MitaHill PassWall `2026.5.17-r1` and its Chinese translation, selected x86_64 proxy cores and plugins, Bandix, and ext4 disk-management tools. It keeps ImmortalWrt's default LAN address (`192.168.1.1`) and no root password.

## First-boot partition expansion

`files/etc/init.d/expand-rootfs` runs after mount setup. It grows only the current ext4 root partition, only when that partition is the last partition on its disk, then records `/etc/.rootfs-expanded`. SATA, VirtIO, and NVMe partition names are supported. A failure is logged and retried at the next boot.
