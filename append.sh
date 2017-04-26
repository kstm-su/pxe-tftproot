#!/bin/bash

DIST=$1
VERSION=$2
ARCH=$3

if [ -z "$DIST" -o -z "$VERSION" -o -z "$ARCH" ]; then
	echo 'usage: ./append.sh <dist> <version> <arch>' >&2
	exit 1
fi

rm -rf "$DIST/$VERSION/$ARCH"
case $DIST in
'debian') 
	wget "http://ftp.debian.org/$DIST/dists/$VERSION/main/installer-$ARCH/current/images/netboot/netboot.tar.gz" -O "tmp/$DIST-$VERSION-$ARCH.tar.gz"
	mkdir "tmp/$DIST-$VERSION-$ARCH"
	tar xzvf "tmp/$DIST-$VERSION-$ARCH.tar.gz" -C "tmp/$DIST-$VERSION-$ARCH"
	mkdir -p "$DIST/$VERSION"
	mv "tmp/$DIST-$VERSION-$ARCH/$DIST-installer/$ARCH" "$DIST/$VERSION/$ARCH"
	rm -rf tmp/*
	cat <<EOF > "pxelinux.cfg/$DIST-$VERSION-$ARCH.cfg"
label $VERSION-$ARCH
	menu label Debian $VERSION ($ARCH)
	kernel ../$DIST/$VERSION/$ARCH/linux
	append vga=788 initrd=../$DIST/$VERSION/$ARCH/initrd.gz
EOF
	;;

'ubuntu') 
	wget "http://ftp.ubuntu.com/$DIST/dists/$VERSION/main/installer-$ARCH/current/images/netboot/netboot.tar.gz" -O "tmp/$DIST-$VERSION-$ARCH.tar.gz"
	mkdir "tmp/$DIST-$VERSION-$ARCH"
	tar xzvf "tmp/$DIST-$VERSION-$ARCH.tar.gz" -C "tmp/$DIST-$VERSION-$ARCH"
	mkdir -p "$DIST/$VERSION"
	mv "tmp/$DIST-$VERSION-$ARCH/$DIST-installer/$ARCH" "$DIST/$VERSION/$ARCH"
	rm -rf tmp/*
	cat <<EOF > "pxelinux.cfg/$DIST-$VERSION-$ARCH.cfg"
label $VERSION-$ARCH
	menu label Ubuntu $VERSION ($ARCH)
	kernel ../$DIST/$VERSION/$ARCH/linux
	append vga=788 initrd=../$DIST/$VERSION/$ARCH/initrd.gz
EOF
	;;

'centos')
	mkdir -p "$DIST/$VERSION/$ARCH"
	wget "http://mirror.centos.org/$DIST/$VERSION/os/$ARCH/images/pxeboot/initrd.img" -O "$DIST/$VERSION/$ARCH/initrd.img"
	wget "http://mirror.centos.org/$DIST/$VERSION/os/$ARCH/images/pxeboot/vmlinuz" -O "$DIST/$VERSION/$ARCH/vmlinuz"
	cat <<EOF > "pxelinux.cfg/$DIST-$VERSION-$ARCH.cfg"
label $VERSION-$ARCH
	menu label CentOS $VERSION ($ARCH)
	kernel ../$DIST/$VERSION/$ARCH/vmlinuz
	append initrd=../$DIST/$VERSION/$ARCH/initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20$ARCH text
EOF
	;;
esac

if ! `grep "$DIST-$VERSION-$ARCH" "pxelinux.cfg/$DIST.cfg" > /dev/null` ; then
	echo "include pxelinux.cfg/$DIST-$VERSION-$ARCH.cfg" >> "pxelinux.cfg/$DIST.cfg"
fi
