#!/usr/bin/env bash
set -euo pipefail

readonly root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly image_path="${1:?Usage: scripts/qemu-smoke-test.sh path/to/*combined-efi.img.gz}"
readonly test_size="${TEST_DISK_SIZE:-128G}"
readonly test_dir="${TEST_DIR:-$root_dir/test-output}"
readonly serial_socket="${QEMU_SERIAL_SOCKET:-}"

command -v qemu-img >/dev/null || { echo "Install QEMU first: brew install qemu" >&2; exit 1; }
command -v qemu-system-x86_64 >/dev/null || { echo "Install QEMU first: brew install qemu" >&2; exit 1; }
[ -f "$image_path" ] || { echo "Image not found: $image_path" >&2; exit 1; }

efi_code="${QEMU_EFI_CODE:-}"
if [ -z "$efi_code" ] && command -v brew >/dev/null; then
	for candidate in "$(brew --prefix qemu)/share/qemu/edk2-x86_64-code.fd" \
		"$(brew --prefix qemu)/share/qemu/edk2-x86_64-code.secboot.fd"; do
		[ -f "$candidate" ] && efi_code="$candidate" && break
	done
fi
[ -n "$efi_code" ] && [ -f "$efi_code" ] || {
	echo "Set QEMU_EFI_CODE to an x86_64 OVMF/edk2 firmware file." >&2
	exit 1
}

mkdir -p "$test_dir"
test_disk="$test_dir/immortalwrt-${test_size}.img"
if ! gzip -cd "$image_path" >"$test_disk"; then
	[ -s "$test_disk" ] || { echo "Unable to decompress image: $image_path" >&2; exit 1; }
fi
qemu-img resize "$test_disk" "$test_size"

echo "Starting $test_size smoke test. QEMU uses software emulation on Apple Silicon."
echo "LuCI: http://127.0.0.1:8080/  SSH: ssh -p 2222 root@127.0.0.1"
serial_args=(-serial mon:stdio)
if [ -n "$serial_socket" ]; then
	[ ! -e "$serial_socket" ] || { echo "Serial socket already exists: $serial_socket" >&2; exit 1; }
	serial_args=(-chardev "socket,id=serial,path=$serial_socket,server=on,wait=off" -serial chardev:serial -monitor none)
	echo "Serial socket: $serial_socket"
fi
exec qemu-system-x86_64 \
	-machine q35 -accel tcg -m 1024 -smp 2 \
	-drive "if=pflash,format=raw,readonly=on,file=$efi_code" \
	-drive "file=$test_disk,format=raw,if=virtio" \
	-netdev user,id=lan,net=192.168.1.0/24,dhcpstart=192.168.1.10,hostfwd=tcp::2222-192.168.1.1:22,hostfwd=tcp::8080-192.168.1.1:80,hostfwd=tcp::1070-192.168.1.1:1070 \
	-device virtio-net-pci,netdev=lan \
	-netdev user,id=wan,net=192.168.2.0/24,dhcpstart=192.168.2.10 \
	-device virtio-net-pci,netdev=wan \
	"${serial_args[@]}" -display none
