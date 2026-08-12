# ImmortalWrt 24.10.5 x86-64 EFI

This project builds a reproducible, lightly customized ImmortalWrt x86-64 EFI image from the official 24.10.5 ImageBuilder. It uses the release's package repositories and creates Bandix IPKs from pinned upstream revisions, because Bandix is not published in the official feed.

## GitHub Actions build

Use **Actions → Build ImmortalWrt firmware → Run workflow** in the GitHub repository. The workflow downloads the official x86_64 ImageBuilder, builds in an Ubuntu `linux/amd64` Docker container, and uploads the EFI image, QCOW2 conversion, and package manifest as a 14-day workflow artifact.

No local Docker, QEMU, ImageBuilder cache, or test disk is required. The workflow is manually triggered so ordinary documentation changes do not consume build minutes.

## Local build (optional)

If a local build is needed later, download and extract the official 24.10.5 x86_64 ImageBuilder into `imagebuilder/`, then run:

```sh
docker build --platform linux/amd64 -t immortalwrt-24.10.5-builder:latest docker
scripts/imagebuilder
```

The build output is copied to `output/`. It uses MitaHill PassWall `2026.5.17-r1` and its Chinese translation, plus the selected x86_64 cores and plugins (sing-box, Xray, Hysteria, NaiveProxy, Shadowsocks Rust, Shadow-TLS, TUIC and V2Ray data), Bandix, and ext4 disk-management tools. It keeps ImmortalWrt's default LAN address (`192.168.1.1`) and no root password.

## First-boot partition expansion

`files/etc/init.d/expand-rootfs` runs after mount setup. It grows only the current ext4 root partition, only when that partition is the last partition on its disk, then records `/etc/.rootfs-expanded`. SATA, VirtIO, and NVMe partition names are supported. A failure is logged and retried at the next boot.

## QEMU smoke test (optional)

Run the EFI image against a sparse 128 GiB disk:

```sh
scripts/qemu-smoke-test.sh output/immortalwrt-24.10.5-x86-64-generic-ext4-combined-efi.img.gz
```

To repeat with a 1 TiB disk, use `TEST_DISK_SIZE=1T`. The script forwards host port 8080 to LuCI and port 2222 to SSH. On Apple Silicon, x86_64 QEMU uses software emulation and is intended for functional testing, not benchmarks.
