.PHONY: build check

build:
	./scripts/imagebuilder

check:
	bash -n scripts/imagebuilder
	sh -n files/etc/init.d/expand-rootfs files/etc/init.d/refresh-luci-index
	! rg -n 'scripts/(immortalwrt|qemu-smoke-test\.sh)|passwall-naive-migrate' scripts .github README.md
	git diff --check
