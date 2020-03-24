FROM 	debian:testing-slim

RUN	apt-get update && apt-get install -y --no-install-recommends \
		debian-ports-archive-keyring \
		debootstrap patch \
		wget ca-certificates \
		xz-utils \
		\
		gnupg dirmngr \
		parted udev dosfstools xz-utils \
		squashfs-tools \
	&& rm -rf /var/lib/apt/lists/*

# see ".dockerignore"
COPY . /opt/debuerreotype

RUN patch -p1 < /opt/debuerreotype/scripts/debootstrap.patch

RUN set -ex; \
	cd /opt/debuerreotype/scripts; \
	for f in debuerreotype-*; do \
		ln -svL "$PWD/$f" "/usr/local/bin/$f"; \
	done; \
	version="$(debuerreotype-version)"; \
	[ "$version" != 'unknown' ]; \
	echo "debuerreotype version $version"

WORKDIR /tmp

