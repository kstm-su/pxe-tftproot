mkdir tmp
wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz -O tmp/syslinux.tar.gz
tar xzvf tmp/syslinux.tar.gz -C tmp
mv tmp/syslinux-6.03 syslinux
grep -v '^$' dists.txt | awk '$0="pxelinux.cfg/"$1".cfg"' | sort | uniq | xargs touch
cat dists.txt | while read line; do ./append.sh $line; done
mkdir tools
wget http://www.hgst.com/sites/default/files/downloads/dft32_v416_b00_install.IMG -O tools/dft.img
wget http://www.memtest.org/download/5.01/memtest86+-5.01.bin.gz -O tmp/memtest.bin.gz
gunzip tmp/memtest.bin.gz
mv tmp/memtest.bin tools/memtest.bin
