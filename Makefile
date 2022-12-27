TAR = tar

all:

out:
	mkdir out


package: out
	cd src && $(TAR) cJf ../out/container.tar.xz $(patsubst src/%,%,$(wildcard src/*))

xbps: out
	@xbps-create -V >/dev/null 2>&1
	mkdir -p tmp/usr/bin
	cp -r $(wildcard src/*) tmp/usr/bin
	cd tmp && \
		xbps-create -A 'noarch' \
		-s 'A POSIX shell script for creating and managing super small, minimal linux chroots.' \
		-H 'https://github.com/sudo200/container#readme' \
		-l 'UNLICENSE' \
		-m 'sudo200' \
		-n "$$(./usr/bin/container -v | tr ' ' '-' | rev | sed 's/\./_/' | rev)" \
		-D 'dash>=0' \
		-F '/etc/container/container.conf' .
	mv tmp/*.xbps out
	$(RM) -r tmp

clean:
	$(RM) -r out tmp

.PHONY: package clean

